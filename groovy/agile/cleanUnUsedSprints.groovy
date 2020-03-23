// https://jira.atlassian.com/browse/JSWSERVER-11263
// kudos to
import com.atlassian.greenhopper.service.sprint.Sprint
import com.atlassian.greenhopper.service.sprint.SprintManager
import com.atlassian.jira.bc.issue.search.SearchService
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.jql.parser.JqlQueryParser
import com.onresolve.scriptrunner.runner.customisers.JiraAgileBean
import com.onresolve.scriptrunner.runner.customisers.WithPlugin

@WithPlugin("com.pyxis.greenhopper.jira")

@JiraAgileBean
SprintManager sprintManager

def searchService = ComponentAccessor.getComponent(SearchService)
def user = ComponentAccessor.jiraAuthenticationContext.loggedInUser
def jqlQueryParser = ComponentAccessor.getComponent(JqlQueryParser)

sprintManager.getAllSprints().value.findAll {
    !it.closed
}.findAll { Sprint sprint ->
    def query = jqlQueryParser.parseQuery("sprint = $sprint.id")
    def hasNoIssues = !searchService.searchCount(user, query)
    if (hasNoIssues) {
        log.warn("Found sprint '$sprint.name' with no issues.")
    }
    hasNoIssues
}.each { Sprint sprint ->

    // uncomment following two lines to remove sprints
    // log.warn("Removing sprint $sprint.name")
    // sprintManager.deleteSprint(sprint)
}