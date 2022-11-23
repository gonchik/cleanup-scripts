/*
    This script do reindexing the exact tickets unresolved
    The logic works on the next rule:
    Get info from database


*/


import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.IssueManager
import com.atlassian.jira.issue.Issue
import com.atlassian.jira.issue.MutableIssue
import org.ofbiz.core.entity.DelegatorInterface
import org.apache.log4j.Logger
import org.apache.log4j.Level
import org.ofbiz.core.entity.ConnectionFactory
import groovy.sql.Sql
import java.sql.Connection
import com.atlassian.jira.util.ImportUtils
import com.atlassian.jira.issue.index.IssueIndexingService


def log = Logger.getLogger("com.gonchik.scripts.groovy.updateExactIndexOfTickets")
log.setLevel(Level.DEBUG)

def user = ComponentAccessor.getJiraAuthenticationContext().getLoggedInUser()
IssueManager issueManager = ComponentAccessor.getIssueManager()
def issueIndexingService = ComponentAccessor.getComponent(IssueIndexingService.class)

tickets = getUnresolvedTickets('2022-11-15', '2022-11-20')
for (ticket in tickets){
    long ticketId = ticket.get('id') as long
    def issue = issueManager.getIssueObject(ticketId)
    issueIndexingService.reIndex(issue)
    // log.warn issue.key
}


def getUnresolvedTickets(from, to) {
    def delegator = (DelegatorInterface) ComponentAccessor.getComponent(DelegatorInterface)
    String helperName = delegator.getGroupHelperName("default")
    Connection conn = ConnectionFactory.getConnection(helperName)
    Sql sql = new Sql(conn)
    def values = []
    try {
        String s = "SELECT j.id " +
                "FROM jiraissue j " +
                "WHERE resolution is null and created > '${from}' and created < '${to}' "
        values = sql.rows(s)
    } finally {
        sql.close()
    }
    return values;
}