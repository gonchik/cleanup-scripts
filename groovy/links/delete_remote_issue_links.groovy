import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.IssueManager
import com.atlassian.jira.issue.Issue
import com.atlassian.jira.user.ApplicationUser
import com.atlassian.jira.user.ApplicationUsers
import com.atlassian.crowd.embedded.api.User
import com.atlassian.jira.issue.link.RemoteIssueLinkManager

def deleteRemoteIssueLinks(Issue issue) {
    def applicationUser = ComponentAccessor.jiraAuthenticationContext.user
    RemoteIssueLinkManager remoteIssueLinkManager = ComponentAccessor.getComponent(RemoteIssueLinkManager)
    def remoteIssueLinks = remoteIssueLinkManager.getRemoteIssueLinksForIssue(issue)
    remoteIssueLinks.each { remoteIssueLink ->
        remoteIssueLinkManager.removeRemoteIssueLink(remoteIssueLink.id, applicationUser)
    }
    remoteIssueLinks.size()
}

String issueKey = 'GRAILS-166'
IssueManager issueManager = ComponentAccessor.issueManager
def issue = issueManager.getIssueObject(issueKey)
if(issue) {
    def deleteCount = deleteRemoteIssueLinks(issue)
    return "deleted ${deleteCount} links."
} else {
    return "issue not found."
}