boolean isPreview = true
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.fields.screen.issuetype.IssueTypeScreenSchemeManager
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupUnAssociatedIssueTypeScreen")
log.setLevel(Level.DEBUG)

def schemeManager = ComponentAccessor.issueTypeScreenSchemeManager
def sb = new StringBuilder()

sb.append("Deleted issue type screen schemes with no associated projects:<br/><br/>\n")
schemeManager.issueTypeScreenSchemes.each {
    if (it.isDefault()) {
        return
    }
    try {
        if (schemeManager.getProjects(it).size() < 1) {
            sb.append("${it.name}<br/>\n")
            if (!isPreview) {
                schemeManager.removeIssueTypeScreenScheme(it)
            }
        }
    }
    catch (Exception e) {
        sb.append("Error: " + e + "<br/>\n")
    }
}

return sb.toString()