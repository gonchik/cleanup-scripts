import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.bc.project.ProjectService
import com.atlassian.jira.component.ComponentAccessor
import org.apache.log4j.Level
import org.apache.log4j.Logger


def log = Logger.getLogger("com.gonchik.scriptrunner")
log.setLevel(Level.DEBUG)

def projectManager = ComponentAccessor.getProjectManager()
projectCategory = projectManager.getProjectCategoryObjectByName("Archive")

log.debug("Project Category: " + projectCategory.name)

def projects = projectManager.getProjectsFromProjectCategory(projectCategory)
def projectService = ComponentAccessor.getComponent(ProjectService)
def user = ComponentAccessor.jiraAuthenticationContext.loggedInUser


projects.each { project ->
    ProjectService.DeleteProjectValidationResult validationResult = projectService.validateDeleteProject(user, project.getKey());
    if (validationResult.isValid()) {
        ProjectService.DeleteProjectResult result = projectService.deleteProjectAsynchronous(user, validationResult);
        log.debug("Removed ${project.getKey}")
    }
}