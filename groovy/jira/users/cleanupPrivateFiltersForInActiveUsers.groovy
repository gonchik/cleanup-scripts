boolean isPreview = true
/*
    This script do cleanup of filters for inactive users
 */

import com.atlassian.jira.bc.JiraServiceContextImpl
import com.atlassian.jira.bc.JiraServiceContext
import com.atlassian.jira.bc.portal.PortalPageService
import com.atlassian.jira.bc.filter.SearchRequestService
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.user.ApplicationUser
import com.atlassian.jira.bc.user.search.UserSearchService
import com.atlassian.jira.bc.user.search.UserSearchParams
import com.atlassian.jira.favourites.FavouritesManager
import com.atlassian.jira.portal.PortletConfiguration
import org.apache.log4j.Logger
import org.apache.log4j.Level


def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupDashBoardsForInactiveUsers")
log.setLevel(Level.DEBUG)

/**
 * Method to delete private filters
 */

// This script can be run from Jira -> Administration -> Add-ons -> Script Console
log.info("| ID | Name | FavouriteCounts | Owner | Is Private |")
UserSearchService userSearchService = ComponentAccessor.getComponent(UserSearchService.class)
UserSearchParams userSearchParams = (new UserSearchParams.Builder()).allowEmptyQuery(true).includeActive(false).includeInactive(true).maxResults(100000).build()
for (ApplicationUser appUser : userSearchService.findUsers("", userSearchParams)) {
    def searchRequestService = ComponentAccessor.getComponent(SearchRequestService.class)
    def filters = searchRequestService.getOwnedFilters(appUser)
    JiraServiceContext serviceContext = new JiraServiceContextImpl(appUser)
    filters.each { filter ->
        if (filter.permissions.isPrivate()) {
            if (!isPreview) {
                searchRequestService.deleteFilter(serviceContext, (long) filter.id)
            }
            log.debug("| ${filter.id} | ${filter.name} | ${filter.favouriteCount} | ${filter.ownerUserName} | ${filter.permissions.isPrivate()} |")
        }
    }
}