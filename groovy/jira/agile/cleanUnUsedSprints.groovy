// https://jira.atlassian.com/browse/JSWSERVER-11263
// kudos to Jamie Echlin
/*
    Agile: checking unused sprints, it means sprints without tickets
    Attention: the user must has all needful rights
 */

boolean isPreview = true

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

def sb = new StringBuilder()
if (isPreview) {
    sb.append("<b>Please, note it works as preview. For execute change variable isPreview = true </b><br/><br/>\n")
} else {
    sb.append("<b>Please, note it works in execute mode</b><br/><br/>\n")
}

sprintManager.getAllSprints().value.findAll {
    !it.closed
}.findAll { Sprint sprint ->
    def query = jqlQueryParser.parseQuery("sprint = $sprint.id")
    def hasNoIssues = !searchService.searchCount(user, query)
    if (hasNoIssues) {
        log.warn("Found sprint '${sprint.name}' with no issues.")
        sb.append("Found sprint '${sprint.name}' with no issues.<br />\n")
    }
    hasNoIssues
}.each { Sprint sprint ->
    if (!isPreview) {
        sb.append("Removing sprint ${sprint.name} <br />\n")
        log.warn("Removing sprint ${sprint.name}")
        sprintManager.deleteSprint(sprint)
    }
}

return sb.toString()