/*
*  That script used for the merging issue types into Task
*
*  */

import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.IssueManager
import com.atlassian.jira.issue.Issue
import com.atlassian.jira.issue.MutableIssue
import org.apache.log4j.Logger
import org.apache.log4j.Level
import com.atlassian.jira.event.type.*
import com.atlassian.jira.util.ImportUtils
import com.atlassian.jira.issue.index.IssueIndexingService
import com.atlassian.jira.bc.issue.search.SearchService
import com.atlassian.jira.bc.issue.search.SearchService.ParseResult
import com.atlassian.jira.web.bean.PagerFilter


final def log = Logger.getLogger("com.gonchik.scripts.groovy.migrateIntoTaskType")
log.setLevel(Level.DEBUG)

String jqlSearch = 'type= "Crash Dump"'
def newIssueTypeId = "1"

def user = ComponentAccessor.getJiraAuthenticationContext().getLoggedInUser()
IssueManager issueManager = ComponentAccessor.getIssueManager()
SearchService searchService = ComponentAccessor.getComponent(SearchService.class)
SearchService.ParseResult parseResult = searchService.parseQuery(user, jqlSearch)
def projectComponentManager = ComponentAccessor.getProjectComponentManager()

def issueIndexingService = ComponentAccessor.getComponent(IssueIndexingService.class)

// check jql
if (!parseResult.isValid()) {
    return
}

def searchResult = searchService.search(user, parseResult.getQuery(), PagerFilter.getUnlimitedFilter())
def issues = searchResult.results.collect { issueManager.getIssueObject(it.id) }

for (issue in issues) {
    def oldIssueType = issue.issueTypeObject.name
    MutableIssue mutableIssue = issue
    log.debug("old issue type is ${oldIssueType}")
    def newSummary = "${oldIssueType}:" + issue.summary
    mutableIssue.setSummary(newSummary.take(150))
    mutableIssue.setIssueTypeId(newIssueTypeId)
    mutableIssue.store()
    boolean wasIndexing = ImportUtils.isIndexIssues()
    ImportUtils.setIndexIssues(true)
    issueIndexingService.reIndex(mutableIssue)
}
