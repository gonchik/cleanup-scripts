boolean isPreview = true
/*
    This script do cleanup of private filters for inactive users
    Additional:  This script can be run from Jira -> Administration -> Add-ons -> Script Console
    Tested Environment: Jira 8.20.5, 8.13.3
    Contribution: Gonchik Tsymzhitov
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

def sb = new StringBuilder()
if (isPreview) {
    sb.append("<b>Please, note it works as preview. For execute change variable isPreview = true </b><br/><br/>\n")
} else {
    sb.append("<b>Please, note it works in execute mode</b><br/><br/>\n")
}
sb.append("| ID | Name | FavouriteCounts | Owner | Is Private |")
log.info("| ID | Name | FavouriteCounts | Owner | Is Private |")
sb.append("<br/>")
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
            sb.append("| ${filter.id} | ${filter.name} | ${filter.favouriteCount} | ${filter.ownerUserName} | ${filter.permissions.isPrivate()} |")
            sb.append("<br/>\n")
        }
    }
}
return sb.toString()