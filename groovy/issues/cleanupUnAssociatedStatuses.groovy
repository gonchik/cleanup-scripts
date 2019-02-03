boolean isPreview = false
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.config.StatusManager
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupUnAssociatedStatuses")
log.setLevel(Level.DEBUG)

def statusManager = ComponentAccessor.getComponent(StatusManager)
def sb = new StringBuilder()

sb.append("Deleted issue type screen schemes with no associated projects:<br/><br/>\n")
statusManager.statuses.each {
    log.debug it.name
}

return sb.toString()