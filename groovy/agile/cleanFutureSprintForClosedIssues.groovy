/* This script works without notification and history and as a service */
boolean isPreview = true

import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.CustomFieldManager
import com.atlassian.jira.issue.fields.CustomField
import com.atlassian.jira.issue.IssueManager
import com.atlassian.jira.issue.Issue
import com.atlassian.jira.issue.MutableIssue
import org.apache.log4j.Logger
import org.apache.log4j.Level
import com.atlassian.jira.event.type.*
import com.atlassian.jira.util.ImportUtils
import com.onresolve.scriptrunner.runner.customisers.PluginModule
import com.onresolve.scriptrunner.runner.customisers.WithPlugin
import com.atlassian.jira.issue.ModifiedValue
import com.atlassian.jira.issue.util.DefaultIssueChangeHolder
import com.atlassian.jira.issue.index.IssueIndexingService
import com.atlassian.jira.bc.issue.search.SearchService
import com.atlassian.jira.bc.issue.search.SearchService.ParseResult
import com.atlassian.jira.web.bean.PagerFilter
import com.onresolve.scriptrunner.runner.customisers.JiraAgileBean
import java.util.stream.Collectors
import com.atlassian.greenhopper.service.sprint.Sprint
import com.atlassian.greenhopper.service.sprint.SprintIssueService
import com.onresolve.scriptrunner.runner.customisers.WithPlugin

@WithPlugin("com.pyxis.greenhopper.jira")

@JiraAgileBean
SprintIssueService sprintIssueService


def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanFutureSprintValues")
log.setLevel(Level.DEBUG)
def loggedInUser = ComponentAccessor.getJiraAuthenticationContext().getLoggedInUser()
IssueManager issueManager = ComponentAccessor.getIssueManager()
SearchService searchService = ComponentAccessor.getComponent(SearchService.class)
CustomFieldManager customerFieldManager = ComponentAccessor.getCustomFieldManager()
CustomField sprintField = customerFieldManager.getCustomFieldObjectByName("Sprint")

def issueIndexingService = ComponentAccessor.getComponent(IssueIndexingService.class)
def sb = new StringBuilder()
if (isPreview == true) {
    sb.append("<b>Please, note it works as preview. For execute change variable isPreview = true </b><br/><br/>\n")
} else {
    sb.append("<b>Please, note it works in execute mode</b><br/><br/>\n")
}


String jqlSearch = 'Sprint  in futureSprints() and status in (Closed, Done)  '


SearchService.ParseResult parseResult = searchService.parseQuery(loggedInUser, jqlSearch)
if (parseResult.isValid()) {
    def searchResult = searchService.search(loggedInUser, parseResult.getQuery(), PagerFilter.getUnlimitedFilter())
    def issues = searchResult.issues.collect { issueManager.getIssueObject(it.id) }

    for (issue in issues) {
        def customFieldsSprints = sprintField.getValue(issue)
        log.debug customFieldsSprints
        def newSprintValues = []
        def changed = false
        for (sprint in customFieldsSprints){
            if (sprint.state == Sprint.State.FUTURE && !sprint.active){
                changed = true
                continue;
            }
            newSprintValues.add(sprint)
        }
        if (newSprintValues.size == 0) { newSprintValues = null; changed = true; }

        sb.append("Removing future sprint for  ${issue.key} <br />\n")
        if ( changed && !isPreview ){
            sprintField.updateValue(null, issue, new ModifiedValue(null, newSprintValues), new DefaultIssueChangeHolder())
            boolean wasIndexing = ImportUtils.isIndexIssues()
            ImportUtils.setIndexIssues(true);
            log.debug("Reindex issue ${issue.key}")
            issueIndexingService.reIndex(issue)
            ImportUtils.setIndexIssues(wasIndexing)
        }
    }
}

return sb.toString()