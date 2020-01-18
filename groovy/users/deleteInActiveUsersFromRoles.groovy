boolean isPreview = true
// remove inactive users from role
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.ComponentManager
import com.atlassian.jira.bc.user.search.UserSearchService
import com.atlassian.jira.bc.user.search.UserSearchParams
import com.atlassian.jira.user.ApplicationUser
import com.atlassian.jira.util.SimpleErrorCollection
import com.atlassian.jira.bc.projectroles.ProjectRoleService
import com.atlassian.jira.project.Project
import org.apache.log4j.Logger
import org.apache.log4j.Level


def log = Logger.getLogger("com.gonchik.scripts.groovy.deleteInActiveUsersFromGroupAndRoles")
log.setLevel(Level.DEBUG)


UserSearchService userSearchService = ComponentAccessor.getComponent(UserSearchService.class)
UserSearchParams userSearchParams = (new UserSearchParams.Builder()).allowEmptyQuery(true).includeActive(false).includeInactive(true).maxResults(100000).build()
for (ApplicationUser appUser : userSearchService.findUsers("", userSearchParams)) {
    ApplicationUser user = appUser
    def userUtil = ComponentAccessor.userUtil
    // Remove user from all roles...
    ProjectRoleService projectRoleService = (ProjectRoleService) ComponentManager.getComponentInstanceOfType(ProjectRoleService.class)
    SimpleErrorCollection errorCollection = new SimpleErrorCollection()
    projectRoleService.getProjectsContainingRoleActorByNameAndType(user.getName(), 'atlassian-user-role-actor', errorCollection).each { Project project ->
        log.debug("Remove user ${user.getName()} from roles reference: ${project.getName()}")
        if (!isPreview) {
            projectRoleService.removeAllRoleActorsByNameAndType(user.getName(), 'atlassian-user-role-actor', errorCollection)
        }
    }
    println errorCollection.dump()
}