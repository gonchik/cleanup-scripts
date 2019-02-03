import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.bc.user.search.UserSearchService
import com.atlassian.jira.bc.user.search.UserSearchParams
import com.atlassian.jira.user.ApplicationUser
import com.atlassian.jira.issue.watchers.WatcherManager
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupStopWatchingInactiveUsers")
log.setLevel(Level.DEBUG)

// this script shows how to clean up the inactive watchers
UserSearchService userSearchService = ComponentAccessor.getComponent(UserSearchService.class)
UserSearchParams userSearchParams = (new UserSearchParams.Builder()).allowEmptyQuery(true).includeActive(false).includeInactive(true).maxResults(100000).build()
WatcherManager watcherManager = ComponentAccessor.getComponent(WatcherManager.class)

for (ApplicationUser appUser : userSearchService.findUsers("", userSearchParams)) {
    ApplicationUser userToRemove = appUser
    watcherManager.removeAllWatchesForUser(userToRemove)
    log.debug('Done for ' + userToRemove.getName())
}