boolean isPreview = true
/*
 *  This script investigate the workflows
 *   Purpose: Remove all Inactive or Drafts Workflows in Jira
 */

import com.atlassian.jira.component.ComponentAccessor
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.deleteUnUsedWorkflowsAndWorkflowSchemes")
log.setLevel(Level.DEBUG)

def workflowManager = ComponentAccessor.workflowManager
def schemeManager = ComponentAccessor.workflowSchemeManager
def sb = new StringBuilder()

sb.append("Start to look unused workflows")
if (isPreview) {
    sb.append("<b>Please, note it works as preview. <br/>\n For execute change variable isPreview = true </b><br/><br/>\n")
} else {
    sb.append("<b>Please, note it works in execute mode</b><br/><br/>\n")
}
// review Workflows
workflowManager.workflows.each {
    if (!it.systemWorkflow) {
        def schemes = schemeManager.getSchemesForWorkflow(it)
        if (schemes.size() == 0) {
            sb.append("Workflow remove candidate: ${it.name}<br/>\n")
            if (!isPreview) {
                try {
                    workflowManager.deleteWorkflow(it)
                } catch (Exception e) {}
            }
        }
    }
}
return sb.toString()