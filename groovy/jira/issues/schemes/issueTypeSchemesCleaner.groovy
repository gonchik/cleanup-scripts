boolean isPreview = true
// This script for cleanup of Issue Type Schemes
import com.atlassian.jira.component.ComponentAccessor
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.issueTypeSchemesCleaner")
log.setLevel(Level.DEBUG)

def schemeManager = ComponentAccessor.issueTypeSchemeManager
def sb = new StringBuilder()

if (isPreview) {
    sb.append("<b>Please, note it works as preview. For execute change variable isPreview = true </b><br/><br/>\n")
} else {
    sb.append("<b>Please, note it works in execute mode</b><br/><br/>\n")
}
sb.append("Deleted issue type schemes with no associated projects:<br/><br/>\n")
schemeManager.allSchemes.each {
    if (schemeManager.isDefaultIssueTypeScheme(it)) {
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