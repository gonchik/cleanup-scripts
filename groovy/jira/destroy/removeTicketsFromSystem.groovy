import java.util.concurrent.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import com.atlassian.jira.issue.search.SearchProvider
import com.atlassian.jira.jql.parser.JqlQueryParser
import com.atlassian.jira.web.bean.PagerFilter
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.user.ApplicationUser
import com.atlassian.jira.issue.MutableIssue
import com.atlassian.jira.issue.Issue

import com.atlassian.jira.issue.search.SearchQuery


final Logger log = LoggerFactory.getLogger(this.getClass())
// log.setLevel(Log)
log.warn("Review threading")

// jql
final def JQL = "created < startOfMonth(-10) "
//Thread number
THREADS = 300
pool = Executors.newFixedThreadPool(THREADS)
defer = { c -> pool.submit(c as Callable) }


List<Issue> issues = getIssues()
log.warn(issues.toString())

def issueManager = ComponentAccessor.getIssueManager()

// task
def deleteTicket = { ticket ->
    log.warn(ticket.key)
    issueManager.deleteIssueNoEvent(ticket)
}


def up = issues.collect { ur ->
    try {
        def url = ur
        defer { deleteTicket(url) }.get()

    } catch (Exception e) {
        return false
    }
}

log.warn(up)
pool.shutdown()


def List<Issue> getIssues() {
    def jqlQueryParser = ComponentAccessor.getComponent(JqlQueryParser.class)
    def searchProvider = ComponentAccessor.getComponent(SearchProvider.class)
    def issueManager = ComponentAccessor.getIssueManager()
    ApplicationUser user = ComponentAccessor.jiraAuthenticationContext.loggedInUser
    def query = jqlQueryParser.parseQuery(JQL)
    def searchQuery = SearchQuery.create(query, user)
    def searchResult = searchProvider.search(searchQuery, PagerFilter.getUnlimitedFilter())
    def issues = searchResult.getResults()*.document.collect { issueManager.getIssueObject(it.getValues('issue_id').first() as Long) };
    return issues
}
