// please, be informed that script works based on the exception for com.atlassian.jira.config.StatusManager.removeStatus()
// Disclaimer: please, check on test env before run prod
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.config.StatusManager
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupUnAssociatedStatuses")
log.setLevel(Level.DEBUG)

def statusManager = ComponentAccessor.getComponent(StatusManager)
def sb = new StringBuilder()

sb.append("Delete statuses with no associated workflow:<br/><br/>\n")
statusManager.statuses.each {
    try {
        statusManager.removeStatus(it.id)
        sb.append("Removed status ${it.name}<br/>\n")
    } catch (Exception e) {
        log.error(e)
    }
}

return sb.toString()