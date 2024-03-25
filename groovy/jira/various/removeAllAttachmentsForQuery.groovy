/*
    Remove all attachments for exact JQL
*/


import com.atlassian.jira.bc.issue.search.SearchService
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.Issue
import com.atlassian.jira.issue.index.IssueIndexingService
import org.apache.log4j.Logger
import com.atlassian.jira.issue.IssueManager
import com.atlassian.jira.web.bean.PagerFilter
import com.atlassian.jira.bc.issue.search.SearchService
import com.atlassian.jira.bc.issue.search.SearchService.ParseResult
import com.atlassian.jira.issue.AttachmentManager

def user = ComponentAccessor.getJiraAuthenticationContext().getLoggedInUser()
SearchService searchService = ComponentAccessor.getComponent(SearchService.class)
IssueManager issueManager = ComponentAccessor.getIssueManager()
def issueIndexingService = ComponentAccessor.getComponent(IssueIndexingService.class)

String jqlSearch = 'attachments is not EMPTY AND status = Done AND issuetype in ("Personal Data Entry", "Company Registration")  and updated > startOfYear() '
SearchService.ParseResult parseResult = searchService.parseQuery(user, jqlSearch)
AttachmentManager atm = ComponentAccessor.getAttachmentManager()
// does JQL valid?
if (!parseResult.isValid()) {
    return "Please, validate a JQL"
}

def searchResult = searchService.search(user, parseResult.getQuery(), PagerFilter.getUnlimitedFilter())
def issues = searchResult.results.collect { issueManager.getIssueObject(it.id) }

for (issue in issues) {
    log.debug "issue.key is cleaning attachments"
    def atms = atm.getAttachments(issue)
    atms.each {
        it -> atm.deleteAttachment(it)
    }
    issueIndexingService.reIndex(issue)
}

def line = "Script successfully migrated data  for ${issues.size()} issues"
log.debug line
return line