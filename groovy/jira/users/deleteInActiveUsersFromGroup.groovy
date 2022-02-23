boolean isPreview = true
/*
    Remove inactive (disabled) users from groups
    Additional:  This script can be run from Jira -> Administration -> Add-ons -> Script Console
    Tested Environment: Jira 8.20.5, 8.13.3
    Contribution: Gonchik Tsymzhitov
 */
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

def sb = new StringBuilder()
def BR = "<br/>\n"
log.debug("Start to review users")
sb.append("Start to review users" + BR)
for (ApplicationUser appUser : userSearchService.findUsers("", userSearchParams)) {
    ApplicationUser user = appUser
    def userUtil = ComponentAccessor.userUtil
    // get the first user of the first group which has the ADMIN privilege...
    // cannot use current user, not really sure who that is when run as a service
    // Remove user from all groups...
    def groups = userUtil.getGroupsForUser(user.name)
    if (!groups.isEmpty()) {
        for (def group : groups) {
            try {
                if (!isPreview) {
                    userUtil.removeUserFromGroup(group, user)
                    log.info(user.name + " removed from group " + group.name)
                    sb.append(user.name + " removed from group " + group.name + BR)
                } else {
                    log.info(user.name + " will be removed from group " + group.name)
                    sb.append(user.name + " will be removed from group " + group.name + BR)
                }
            } catch (Exception e) {
                log.info(user.name + " should be reviewed in AD (read-only) group " + group.name)
                sb.append(user.name + " should be reviewed in AD (read-only) group " + group.name + BR)
            }
        }
    }
}

return sb