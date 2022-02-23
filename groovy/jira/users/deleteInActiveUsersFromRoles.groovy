boolean isPreview = true
/*
    Remove inactive users from project roles in Projects
    Additional:  This script can be run from Jira -> Administration -> Add-ons -> Script Console
    Tested Environment: Jira 8.20.5, 8.13.3
    Contribution: Gonchik Tsymzhitov
 */
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.component.pico.ComponentManager
import com.atlassian.jira.bc.user.search.UserSearchService
import com.atlassian.jira.bc.user.search.UserSearchParams
import com.atlassian.jira.user.ApplicationUser
import com.atlassian.jira.util.SimpleErrorCollection
import com.atlassian.jira.bc.projectroles.ProjectRoleService
import com.atlassian.jira.project.Project

def sb = new StringBuilder()

UserSearchService userSearchService = ComponentAccessor.getComponent(UserSearchService.class)
UserSearchParams userSearchParams = (new UserSearchParams.Builder()).allowEmptyQuery(true).includeActive(false).includeInactive(true).maxResults(100000).build()
def line = ""
for (ApplicationUser appUser : userSearchService.findUsers("", userSearchParams)) {
    ApplicationUser user = appUser
    def userUtil = ComponentAccessor.userUtil
    // Remove user from all roles...
    ProjectRoleService projectRoleService = ComponentAccessor.getComponent(ProjectRoleService.class)
    SimpleErrorCollection errorCollection = new SimpleErrorCollection()
    projectRoleService.getProjectsContainingRoleActorByNameAndType(user.getName(), 'atlassian-user-role-actor', errorCollection).each { Project project ->
        if (!isPreview) {
            line = "Removing user ${user.getName()} from roles reference: ${project.getName()} <br>"
            projectRoleService.removeAllRoleActorsByNameAndType(user.getName(), 'atlassian-user-role-actor', errorCollection)
        } else {
            line = "Planning to remove user ${user.getName()} from roles reference: ${project.getName()} <br>"
        }
        sb.append(line)
    }
}
return sb.toString()