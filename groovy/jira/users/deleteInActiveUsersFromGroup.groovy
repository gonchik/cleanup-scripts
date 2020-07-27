boolean isPreview = true
// cleanup inactive users groups
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.bc.user.search.UserSearchService
import com.atlassian.jira.bc.user.search.UserSearchParams
import com.atlassian.jira.user.ApplicationUser
import org.apache.log4j.Logger
import org.apache.log4j.Level


def log = Logger.getLogger("com.gonchik.scripts.groovy.deleteInActiveUsersFromGroupAndRoles")
log.setLevel(Level.DEBUG)


UserSearchService userSearchService = ComponentAccessor.getComponent(UserSearchService.class)
UserSearchParams userSearchParams = (new UserSearchParams.Builder()).allowEmptyQuery(true).includeActive(false).includeInactive(true).maxResults(100000).build()
for (ApplicationUser appUser : userSearchService.findUsers("", userSearchParams)) {
    ApplicationUser user = appUser
    def userUtil = ComponentAccessor.userUtil
    // get the first user of the first group which has the ADMIN privilege...
    // cannot use current user, not really sure who that is when run as a service
    // Remove user from all groups...
    def groups = userUtil.getGroupsForUser(user.name)
    if (!groups.isEmpty()) {
        for (def group : groups){
            try {
                if (!isPreview){userUtil.removeUserFromGroup(group, user)}
                log.info(user.name + " removed from group " + group.name)
            } catch (Exception e) {
                log.info(user.name + " should be reviewed in AD (read-only) group " + group.name)
            }
        }
    }
}