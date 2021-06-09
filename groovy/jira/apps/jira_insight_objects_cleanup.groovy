import com.atlassian.jira.component.ComponentAccessor
import com.riadalabs.jira.plugins.insight.services.model.ObjectAttributeBean
import com.riadalabs.jira.plugins.insight.services.model.ObjectBean
import com.riadalabs.jira.plugins.insight.channel.external.api.facade.IQLFacade
import com.riadalabs.jira.plugins.insight.channel.external.api.facade.ObjectFacade
import com.onresolve.scriptrunner.runner.customisers.PluginModule
import com.onresolve.scriptrunner.runner.customisers.WithPlugin
@WithPlugin('com.riadalabs.jira.plugins.insight')

@PluginModule
IQLFacade iqlFacade

@PluginModule
ObjectFacade objFacade


// Please,  validate query using UI of Insight
// def query = 'objectSchemaId = 4 ... etc '


try {
    iqlFacade.validateIQL(query)
} catch (Exception e) {
    if (log) log.error("FAILED TO QUERY: ")
    return null
}

def objects = iqlFacade.findObjects(query)
for (def object : objects) {
    try {
        objFacade.deleteObjectBean(object.getId())
    } catch (Exception e) {
        // just skip
    }
}
//
return "DONE"