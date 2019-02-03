boolean isPreview = true
import com.atlassian.jira.component.ComponentAccessor
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupUnUsedFieldScreens")
log.setLevel(Level.DEBUG)

def schemeManager = ComponentAccessor.fieldScreenSchemeManager
def sb = new StringBuilder()

sb.append("Deleted issue type screen schemes with no associated projects:<br/><br/>\n")
schemeManager.fieldScreenSchemes().each {
    if (it.isDefault()) {
        return
    }
    try {
        if (schemeManager.getProjects(it).size() == 0) {
            sb.append("${it.name}<br/>\n")
            if (!isPreview) {
                schemeManager.removeFieldScreenScheme(it)
            }
        }
    }
    catch (Exception e) {
        sb.append("Error: " + e + "<br/>\n")
    }
}

return sb.toString()