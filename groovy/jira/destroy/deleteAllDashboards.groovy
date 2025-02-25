boolean isPreview = true
/*
*
*   Remove all dashboards
*
*/

import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.portal.PortalPage
import com.atlassian.jira.portal.PortalPageManager
import com.atlassian.jira.util.collect.EnclosedIterable.Functions
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.deleteAllDashboards")
log.setLevel(Level.DEBUG)
def sb = new StringBuilder()

if (isPreview) {
    sb.append("<b>Please, note it works as preview. For execute change variable isPreview = true </b><br/><br/>\n")
} else {
    sb.append("<b>Please, note it works in execute mode</b><br/><br/>\n")
}

def BR = "<br/>\n"
log.debug("Start review dashboards")
PortalPageManager ppm = ComponentAccessor.getComponent(PortalPageManager.class)
for (PortalPage portalPage in Functions.toList(ppm.getAll())) {
    if (!isPreview) {
        sb.append("Removing dashboard ${portalPage.getName()} " + BR)
        log.warn("Removing dashboard ${portalPage.getName()}")
        ppm.delete(portalPage.getId())
    } else {
        sb.append("Marking for remove dashboard ${portalPage.getName()} " + BR)
        log.warn("Marking for remove dashboard ${portalPage.getName()}")
    }

}
return sb