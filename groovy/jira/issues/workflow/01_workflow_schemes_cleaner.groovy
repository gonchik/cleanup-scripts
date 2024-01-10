boolean isPreview = true
/*
     This script investigate workflows schemes
     Additional:
     This script can be run from Jira:
        -> Administration -> Scriptrunner -> Console
     or
        -> Administration -> Apps -> Script Console
     Tested Environment: Jira 8.20.x, 9.4.x
     Contribution: Gonchik Tsymzhitov
 */

import com.atlassian.jira.component.ComponentAccessor
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.workflowSchemesCleaner")
log.setLevel(Level.DEBUG)

def workflowManager = ComponentAccessor.workflowManager
def schemeManager = ComponentAccessor.workflowSchemeManager
def sb = new StringBuilder()
sb.append("Start to detect unused workflow schemes <br>")
if (isPreview) {
    sb.append("<b>Please, note it works as preview. For execute change variable isPreview = true </b><br/><br/>\n")
} else {
    sb.append("<b>Please, note it works in execute mode</b><br/><br/>\n")
}
// Review workflow schemes
schemeManager.schemeObjects.each {
    try {
        if (schemeManager.getProjectsUsing(schemeManager.getWorkflowSchemeObj(it.id)).size() == 0) {
            sb.append("Workflow scheme remove candidate: ${it.name}<br/>\n")
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