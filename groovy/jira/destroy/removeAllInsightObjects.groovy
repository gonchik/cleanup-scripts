import com.atlassian.jira.component.ComponentAccessor
import com.onresolve.scriptrunner.runner.customisers.WithPlugin
@WithPlugin('com.riadalabs.jira.plugins.insight')
import com.riadalabs.jira.plugins.insight.channel.external.api.facade.IQLFacade
import com.riadalabs.jira.plugins.insight.channel.external.api.facade.ObjectFacade
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.removeInsightObjects")
log.setLevel(Level.DEBUG)

ObjectFacade objectFacade = ComponentAccessor.getOSGiComponentInstanceOfType(ObjectFacade)
IQLFacade iqlFacade = ComponentAccessor.getOSGiComponentInstanceOfType(IQLFacade)
def objects = iqlFacade.findObjectsByIQL(/objectSchema = "PepsiCo Issues Snapshots"  /)
objects.each {
    log.debug("Dropping ${it.name}")
    objectFacade.deleteObjectBean(it.id)
}

