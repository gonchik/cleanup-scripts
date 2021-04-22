boolean isPreview = true

import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.bc.user.search.UserSearchService
import com.atlassian.jira.bc.user.search.UserSearchParams
import com.atlassian.jira.user.ApplicationUser
import com.atlassian.jira.user.util.UserUtil
import com.atlassian.jira.util.SimpleErrorCollection
import com.atlassian.jira.bc.projectroles.ProjectRoleService
import com.atlassian.jira.project.Project
import com.atlassian.crowd.embedded.api.Group
import com.atlassian.jira.security.roles.actor.UserRoleActorFactory
import com.atlassian.jira.security.GlobalPermissionManager
import org.apache.log4j.Logger
import org.apache.log4j.Level


def log = Logger.getLogger("com.gonchik.scripts.groovy.deleteInActiveUsersFromGroupAndRoles")
log.setLevel(Level.DEBUG)


UserSearchService userSearchService = ComponentAccessor.getComponent(UserSearchService.class)
UserSearchParams userSearchParams = (new UserSearchParams.Builder()).allowEmptyQuery(true).includeActive(false).includeInactive(true).maxResults(100000).build()
def sb = new StringBuilder()
def BR = "<br/>\n"
log.debug("Start review users")
sb.append("Start review users" + BR)
for (ApplicationUser appUser : userSearchService.findUsers("", userSearchParams)) {
    ApplicationUser user = appUser
    def userUtil = ComponentAccessor.userUtil
    // get the first user of the first group which has the ADMIN privilege...
    // cannot use current user, not really sure who that is when run as a service
    def adminUser = userUtil.getJiraAdministrators()[0]
    sb.append("deactivateUser ${user.getName()}" + BR)
    log.debug("deactivateUser ${user.getName()}")
    // Remove user from all groups...
    def groups = userUtil.getGroupsForUser(user.name)
    if (!groups.isEmpty() && !isPreview) {
        try {
            userUtil.removeUserFromGroups(groups, user)
            log.info(userToRemove.name + " from groups")
            sb.append(userToRemove.name + " from groups" + BR)
        } catch (Exception e) {
            log.info(user.name + " should be reviewed in AD")
            sb.append(user.name + " should be reviewed in AD")
            log.error(e)
        }
    }
    // Remove user from all roles...
    ProjectRoleService projectRoleService = (ProjectRoleService) ComponentAccessor.getComponentOfType(ProjectRoleService.class)
    SimpleErrorCollection errorCollection = new SimpleErrorCollection()
    log.debug("Removing all roles references for ${user.getName()}")
    sb.append("Removing all roles references for ${user.getName()}")
    projectRoleService.getProjectsContainingRoleActorByNameAndType(adminUser, user.getName(), 'atlassian-user-role-actor', errorCollection).each { Project project ->
        log.debug("Remove user ${user.getName()} from role: ${project.getName()}")
        sb.append("Remove user ${user.getName()} from role: ${project.getName()}")
    }
    if (!isPreview) {
        projectRoleService.removeAllRoleActorsByNameAndType(adminUser, user.getName(), 'atlassian-user-role-actor', errorCollection)
    }
    println errorCollection.dump()
}
return sb.toString()