/*
    This script do decrease of counters filters, dashboards for inactive users
 */
boolean isPreview = true
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
 * Method to delete private dashboards
 */

// This script can be run from Jira -> Administration -> Add-ons -> Script Console
log.info("| ID | Name | FavouriteCounts | Owner | Is Private |")
UserSearchService userSearchService = ComponentAccessor.getComponent(UserSearchService.class)
UserSearchParams userSearchParams = (new UserSearchParams.Builder()).allowEmptyQuery(true).includeActive(false).includeInactive(true).maxResults(100000).build()
for (ApplicationUser appUser : userSearchService.findUsers("", userSearchParams)) {
    def favouritesManager = ComponentAccessor.getComponent(FavouritesManager.class)
    def portalPageService = ComponentAccessor.getComponent(PortalPageService.class)
    def pages = portalPageService.getFavouritePortalPages(appUser)
    JiraServiceContext serviceContext = new JiraServiceContextImpl(appUser)
    def isFavourite = false
    pages.each { page ->
        if (!isPreview) {
            portalPageService.updatePortalPage(serviceContext, page, isFavourite)
            favouritesManager.removeFavourite(appUser, page)
        }
        log.debug("| ${page.id} | ${page.name} | ${page.favouriteCount} | ${page.ownerUserName} | ${page.permissions.isPrivate()} |")
    }

    // decrease the filter counts
    def searchRequestService = ComponentAccessor.getComponent(SearchRequestService.class)
    def filters = searchRequestService.getFavouriteFilters(appUser)
    filters.each { filter ->
        if (!isPreview) {
            searchRequestService.updateFilter(serviceContext, filter, isFavourite)
            favouritesManager.removeFavourite(appUser, filter)
        }
        log.debug("| ${filter.id} | ${filter.name} | ${filter.favouriteCount} | ${filter.ownerUserName} | ${filter.permissions.isPrivate()} |")
    }
}