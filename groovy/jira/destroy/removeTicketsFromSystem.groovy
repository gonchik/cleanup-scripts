import com.atlassian.jira.issue.search.SearchProvider
import com.atlassian.jira.jql.parser.JqlQueryParser
import com.atlassian.jira.web.bean.PagerFilter
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.user.ApplicationUser
import com.atlassian.jira.issue.MutableIssue
import com.atlassian.jira.issue.search.SearchQuery

def jqlQueryParser = ComponentAccessor.getComponent(JqlQueryParser.class)
def searchProvider = ComponentAccessor.getComponent(SearchProvider.class)
def issueManager = ComponentAccessor.getIssueManager()
def userManager = ComponentAccessor.getUserManager()
def user = ComponentAccessor.jiraAuthenticationContext.loggedInUser

def query = jqlQueryParser.parseQuery("created < startOfYear() ")
def searchQuery = SearchQuery.create(query, user)
def searchResult = searchProvider.search(searchQuery, PagerFilter.getUnlimitedFilter())
def issues = searchResult.getResults().collect { issueManager.getIssueObject(it.getDocId()) };

issues.each { issue ->
    issueManager.deleteIssueNoEvent(issue)
}