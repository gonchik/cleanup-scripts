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
def BR = "<br/>\n"
log.debug("Start review dashboards")
PortalPageManager ppm = ComponentAccessor.getComponent(PortalPageManager.class)
for (PortalPage portalPage in Functions.toList(ppm.getAll())) {
    log.debug(portalPage.getName())
    sb.append(portalPage.getName() + BR)
    ppm.delete(portalPage.getId())
}
return sb