boolean isPreview = false
// This script investigate the workflows and workflows schemes
import com.atlassian.jira.component.ComponentAccessor
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.deleteUnUsedWorkflows")
log.setLevel(Level.DEBUG)

def workflowManager = ComponentAccessor.workflowManager
def schemeManager = ComponentAccessor.workflowSchemeManager
def sb = new StringBuilder()

// review Workflows
workflowManager.workflows.each {
    if (!it.systemWorkflow) {
        def schemes = schemeManager.getSchemesForWorkflow(it)
        if (schemes.size() == 0) {
            sb.append("Workflow candidate: ${it.name}<br/>\n")
            if (!isPreview) {
                workflowManager.deleteWorkflow(it)
            }
        }
    }
}

// Review workflow schemes
schemeManager.schemeObjects.each {
    try {
        if (schemeManager.getProjectsUsing(schemeManager.getWorkflowSchemeObj(it.id)).size() == 0) {
            sb.append("Workflow scheme candidate: ${it.name}<br/>\n")
            if (!isPreview) {
                schemeManager.deleteScheme(it.id)
            }
        }
    }
    catch (Exception e) {
        log.error('Something wrong, ' + e)
        sb.append("Error: " + e + "<br/>\n")
    }
}
return sb.toString()