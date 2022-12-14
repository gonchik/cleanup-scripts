/*
    Remove all attachments for exact ticket
*/

import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.Issue
import org.apache.log4j.Logger
import com.atlassian.jira.issue.IssueManager

import com.atlassian.jira.issue.AttachmentManager


IssueManager im = ComponentAccessor.getIssueManager()
def issue = im.getIssueObject('FM-773')

AttachmentManager atm = ComponentAccessor.getAttachmentManager()
def atms = atm.getAttachments(issue)
atms.each {
    it -> atm.deleteAttachment(it)
}