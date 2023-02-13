/*
    This script do decrease of counters filters, dashboards for inactive users
    Additional:  This script can be run from Jira -> Administration -> Add-ons -> Script Console
    Tested Environment: Jira 8.20.5, 8.13.3
    Contribution: Gonchik Tsymzhitov
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

def sb = new StringBuilder()
def line = "| ID | Name | FavouriteCounts | Owner | Is Private |"
sb.append(line)
log.info(line)
def BR = "<br/>\n"

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
        line = "| ${page.id} | ${page.name} | ${page.favouriteCount} | ${page.ownerUserName} | ${page.permissions.isPrivate()} |"
        sb.append(line + BR)
        log.debug(line)
    }

    // decrease the filter counts
    def searchRequestService = ComponentAccessor.getComponent(SearchRequestService.class)
    def filters = searchRequestService.getFavouriteFilters(appUser)
    filters.each { filter ->
        if (!isPreview) {
            searchRequestService.updateFilter(serviceContext, filter, isFavourite)
            favouritesManager.removeFavourite(appUser, filter)
        }
        line = "| ${filter.id} | ${filter.name} | ${filter.favouriteCount} | ${filter.ownerUserName} | ${filter.permissions.isPrivate()} |"
        sb.append(line + BR)
        log.debug(line)
    }
}


return sb.toString()