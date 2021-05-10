/* This script works without notification and as a service
*  clean change items, it helps for programmatically create cases */

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
import com.atlassian.jira.issue.ModifiedValue
import com.atlassian.jira.issue.util.DefaultIssueChangeHolder
import com.atlassian.jira.issue.index.IssueIndexingService
import com.atlassian.jira.bc.issue.search.SearchService
import com.atlassian.jira.bc.issue.search.SearchService.ParseResult
import com.atlassian.jira.web.bean.PagerFilter


final def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupChangeItems")
log.setLevel(Level.DEBUG)

String jqlSearch = 'project=TEST and status=Closed and resolution is Empty'
def newResolutionId = ""
def user = ComponentAccessor.getJiraAuthenticationContext().getLoggedInUser()
IssueManager issueManager = ComponentAccessor.getIssueManager()
SearchService searchService = ComponentAccessor.getComponent(SearchService.class)
SearchService.ParseResult parseResult = searchService.parseQuery(user, jqlSearch)

def issueIndexingService = ComponentAccessor.getComponent(IssueIndexingService.class)

// does JQL valid?
if (!parseResult.isValid()) {
    return "Please, validate a JQL"
}


def searchResult = searchService.search(user, parseResult.getQuery(), PagerFilter.getUnlimitedFilter())
def issues = searchResult.results.collect { issueManager.getIssueObject(it.id) }

for (issue in issues) {
    if (!newResolutionId) {
        return
    }
    def oldResolutionDate = issue.getResolutionDate()
    issue.setResolutionId(newResolutionId)
    issue.setResolutionDate(oldResolutionDate)
    issue.store()
    def changed = true
    if (changed) {
        log.debug "Done for ${issue.key}"
        boolean wasIndexing = ImportUtils.isIndexIssues()
        ImportUtils.setIndexIssues(true);
        log.warn("Reindex issue ${issue.key} ${issue.id}")
        issueIndexingService.reIndex(issue)
        ImportUtils.setIndexIssues(wasIndexing)
    }
}
