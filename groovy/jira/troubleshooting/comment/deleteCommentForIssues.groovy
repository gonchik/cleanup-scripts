/* This script works without notification and as a service */

import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.CustomFieldManager
import com.atlassian.jira.issue.fields.CustomField
import com.atlassian.jira.issue.IssueManager
import com.atlassian.jira.issue.Issue
import com.atlassian.jira.issue.MutableIssue
import org.apache.log4j.Logger
import org.apache.log4j.Level
import com.atlassian.jira.event.type.*
import com.atlassian.jira.bc.issue.search.SearchService
import com.atlassian.jira.bc.issue.search.SearchService.ParseResult
import com.atlassian.jira.web.bean.PagerFilter
import com.atlassian.jira.issue.customfields.manager.OptionsManager
import com.atlassian.jira.issue.comments.CommentManager
import com.atlassian.jira.issue.comments.Comment


def log = Logger.getLogger("com.gonchik.scripts.groovy.setAccountValueFromCustomerAccount")
log.setLevel(Level.DEBUG)

String jqlSearch = 'key=SDK-154141'
def user = ComponentAccessor.getJiraAuthenticationContext().getLoggedInUser()
IssueManager issueManager = ComponentAccessor.getIssueManager()
SearchService searchService = ComponentAccessor.getComponent(SearchService.class)
SearchService.ParseResult parseResult = searchService.parseQuery(user, jqlSearch)
CommentManager commentManager = ComponentAccessor.commentManager

if (parseResult.isValid()) {
    def searchResult = searchService.search(user, parseResult.getQuery(), PagerFilter.getUnlimitedFilter())
    def issues = searchResult.results.collect { issueManager.getIssueObject(it.id) }
    for (issue in issues) {
        commentManager.deleteCommentsForIssue(issue);
    }
}
