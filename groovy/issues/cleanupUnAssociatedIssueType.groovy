boolean isPreview = true

import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.config.IssueTypeManager
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupUnAssociatedIssueType")
log.setLevel(Level.DEBUG)

// Cleanup of the cleanupUnAssociatedIssueType
def issueTypeManager = ComponentAccessor.getComponent(IssueTypeManager)
def sb = new StringBuilder()

sb.append("Deleted issue type schemes with no associated projects:<br/><br/>\n")
issueTypeManager.issueTypes.each {
    try {
        if (!issueTypeManager.hasAssociatedIssues(it)) {
            sb.append("${it.name}<br/>\n")
            if (!isPreview) {
                // Set the Default of Task Id
                String replaceIssueTypeId = "1"
                if (it.isSubTask()){
                    // Id of Sub-Task
                    replaceIssueTypeId = "5"
                }
                issueTypeManager.removeIssueType(it.id, replaceIssueTypeId)
            }
        }
    }
    catch (Exception e) {
        sb.append("Error: " + e + "<br/>\n")
    }
}

return sb.toString()