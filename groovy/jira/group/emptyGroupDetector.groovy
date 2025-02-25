/*
    Find empty groups in Jira
    Additional:  This script can be run from Jira -> Administration -> Add-ons -> Script Console
    Tested Environment: Jira 8.20.5, 8.13.3, 9.12.5
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

def groupManager = ComponentAccessor.getGroupManager()

def allGroups = groupManager.getAllGroups()
def sb = new StringBuilder()
def BR = "<br/>\n"
log.debug("Start review users")
sb.append("Start review users" + BR)

for (def group : allGroups) {
    def userCount = groupManager.getUsersInGroupCount(group)
    if (userCount && userCount > 0) {
        continue;
    }
    sb.append(group.name + BR)
    log.debug(group.name)
}

return sb