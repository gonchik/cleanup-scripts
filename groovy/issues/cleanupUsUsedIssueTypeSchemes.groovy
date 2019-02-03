boolean isPreview = false
import com.atlassian.jira.component.ComponentAccessor
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupUsUsedIssueTypeSchemes")
log.setLevel(Level.DEBUG)

def schemeManager = ComponentAccessor.issueTypeSchemeManager
def sb = new StringBuilder()

sb.append("Deleted issue type schemes with no associated projects:<br/><br/>\n")
schemeManager.allSchemes.each {
    if (schemeManager.isDefaultIssueTypeScheme(it)){
        return
    }
    try {
        if (it.associatedProjectIds.size() == 0) {
            sb.append("${it.name}<br/>\n")
            if (!isPreview) {
                schemeManager.deleteScheme(it)
            }
        }
    }
    catch (Exception e) {
        sb.append("Error: " + e + "<br/>\n")
    }
}

return sb.toString()