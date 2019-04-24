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
 * That method delete Private Dashboards
 * @param appUser
 * @return
 */
def deletePrivateDashBoards(ApplicationUser appUser, int notPopularCount) {
    def portalPageService = ComponentAccessor.getComponent(PortalPageService.class)
    def pages = portalPageService.getOwnedPortalPages(appUser)
    JiraServiceContext serviceContext = new JiraServiceContextImpl(appUser)
    pages.each { page ->
        if (page.permissions.isPrivate() || page.favouriteCount < notPopularCount) {
            portalPageService.deletePortalPage(serviceContext, (long) page.id)
            log.debug "| ${page.id} | ${page.name} | ${page.favouriteCount} | ${page.ownerUserName} | ${page.permissions.isPrivate()} |"
        }
    }
}

/**
 * Method to delete private filters
 * @param appUser
 * @return
 */
def deletePrivateFilters(ApplicationUser appUser) {
    def searchRequestService = ComponentAccessor.getComponent(SearchRequestService.class)
    def filters = searchRequestService.getOwnedFilters(appUser)
    JiraServiceContext serviceContext = new JiraServiceContextImpl(appUser)
    filters.each { filter ->
        if (filter.permissions.isPrivate()) {
            searchRequestService.deleteFilter(serviceContext, (long) filter.id)
            log.debug "| ${filter.id} | ${filter.name} | ${filter.favouriteCount} | ${filter.ownerUserName} | ${filter.permissions.isPrivate()} |"
        }
    }
}

/**
 * Remove from favourites filters and dashboards for inactive users
 * @param appUser
 * @return
 */
def decreaseFavouriteCounter(ApplicationUser appUser) {
    def favouritesManager = ComponentAccessor.getComponent(FavouritesManager.class)
    def portalPageService = ComponentAccessor.getComponent(PortalPageService.class)
    def pages = portalPageService.getFavouritePortalPages(appUser)
    JiraServiceContext serviceContext = new JiraServiceContextImpl(appUser)
    def isFavourite = false
    pages.each { page ->
        portalPageService.updatePortalPage(serviceContext, page, isFavourite)
        favouritesManager.removeFavourite(appUser, page)
        log.debug "| ${page.id} | ${page.name} | ${page.favouriteCount} | ${page.ownerUserName} | ${page.permissions.isPrivate()} |"
    }

    // decrease the filter counts
    def searchRequestService = ComponentAccessor.getComponent(SearchRequestService.class)
    def filters = searchRequestService.getFavouriteFilters(appUser)
    filters.each { filter ->
        searchRequestService.updateFilter(serviceContext, filter, isFavourite)
        favouritesManager.removeFavourite(appUser, filter)
        log.debug "| ${filter.id} | ${filter.name} | ${filter.favouriteCount} | ${filter.ownerUserName} | ${filter.permissions.isPrivate()} |"
    }
}

def deleteAllDashboardsAndFilters(ApplicationUser appUser){
    def portalPageService = ComponentAccessor.getComponent(PortalPageService.class)
    def searchRequestService = ComponentAccessor.getComponent(SearchRequestService.class)
    JiraServiceContext serviceContext = new JiraServiceContextImpl(appUser)
    // delete all filters and dashboards for user
    portalPageService.deleteAllPortalPagesForUser(appUser)
    searchRequestService.deleteAllFiltersForUser(serviceContext, appUser)
}

def removeGadget(ApplicationUser appUser) {
    // @todo remove only incorrect gadgets
    def portalPageService = ComponentAccessor.getComponent(PortalPageService.class)
    def pages = portalPageService.getOwnedPortalPages(appUser)
    JiraServiceContext serviceContext = new JiraServiceContextImpl(appUser)
    def isFavourite = false
    pages.each { page ->
        def portletConfigurationsList = portalPageService.getPortletConfigurations(serviceContext, (long) page.id)
        portletConfigurationsList.each { portletConfigurations ->
            portletConfigurations.each { portletConfiguration ->
                log.debug portletConfiguration.getGadgetURI()
            }
        }
    }

}

// This script can be run from Jira -> Administration -> Add-ons -> Script Console
log.debug "| ID | Name | FavouriteCounts | Owner | Is Private |"
UserSearchService userSearchService = ComponentAccessor.getComponent(UserSearchService.class)
UserSearchParams userSearchParams = (new UserSearchParams.Builder()).allowEmptyQuery(true).includeActive(false).includeInactive(true).maxResults(100000).build()
for (ApplicationUser appUser : userSearchService.findUsers("", userSearchParams)) {
    decreaseFavouriteCounter(appUser)
    deletePrivateDashBoards(appUser, 1)
    deletePrivateFilters(appUser)
}