boolean isPreview = true
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.fields.screen.FieldScreenSchemeManager
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupUsUsedIssueTypeScreenManager")
log.setLevel(Level.DEBUG)

def schemeManager = ComponentAccessor.getComponent(FieldScreenSchemeManager.class)
def sb = new StringBuilder()

sb.append("Deleted screen schemes with no screens projects:<br/><br/>\n")
schemeManager.getFieldScreenSchemes().each {
    try {
        if (schemeManager.getFieldScreenSchemeItems(it).size() < 1) {
            if (!isPreview) {
                schemeManager.removeFieldScreenScheme(it)
            }
        }
    }
    catch (Exception e) {
        sb.append("Error: " + e + "<br/>\n")
    }
}
schemeManager.refresh()
return sb.toString()