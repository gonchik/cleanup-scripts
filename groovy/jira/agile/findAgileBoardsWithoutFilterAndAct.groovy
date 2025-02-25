boolean isPreview = true
/*
 * Agile: detect Agile boards without any base filter
 * link: https://confluence.atlassian.com/jirakb/jira-software-boards-not-visible-after-filter-deletion-779158656.html
 * Environment (last check): Jira Software 8.20.16, Scriptrunner 7.10.0
 */

import com.atlassian.greenhopper.model.rapid.RapidView
import com.atlassian.greenhopper.manager.rapidview.RapidViewManager
import com.onresolve.scriptrunner.runner.customisers.JiraAgileBean
import com.onresolve.scriptrunner.runner.customisers.WithPlugin
import com.atlassian.jira.issue.search.SearchRequestManager
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.config.properties.APKeys

class NoCheck implements RapidViewManager.RapidViewPermissionCheck {
    boolean check(RapidView view) {
        return true
    }
}

@WithPlugin("com.pyxis.greenhopper.jira")
@JiraAgileBean
RapidViewManager rapidViewManager
SearchRequestManager srm = ComponentAccessor.getComponent(SearchRequestManager)

def sb = new StringBuilder()
if (isPreview) {
    sb.append("<b>Please, note it works as preview. For execute change variable isPreview = true </b><br/><br/>\n")
} else {
    sb.append("<b>Please, note it works in execute mode</b><br/><br/>\n")
}


sb.append("<b>Board id</b> - Name - <b> Owner </b> - LINK <br />\n")
def baseUrl = ComponentAccessor.getApplicationProperties().getString(APKeys.JIRA_BASEURL)
rapidViewManager.getAll(new NoCheck()).value.each { b ->
    if (srm.getSearchRequestById(b.savedFilterId) == null) {
        if (!isPreview) {
            def res = rapidViewManager.delete(b)
        }
        sb.append("<a href='${baseUrl}/secure/RapidBoard.jspa?rapidView=/${b.id}'>${b.id}</a> - ${b.name} - ${b.owner}")
        sb.append("<br />\n")
    }
}

return sb.toString()