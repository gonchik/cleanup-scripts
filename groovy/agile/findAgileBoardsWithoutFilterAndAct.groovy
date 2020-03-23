boolean isPreview = true
// https://kb.botronsoft.com/x/gYBk
// Find Agile boards without any base filter
import com.atlassian.greenhopper.model.rapid.RapidView
import com.atlassian.greenhopper.manager.rapidview.RapidViewManager
import com.onresolve.scriptrunner.runner.customisers.JiraAgileBean
import com.atlassian.jira.issue.search.SearchRequestManager
import com.atlassian.jira.component.ComponentAccessor

public class NoCheck implements RapidViewManager.RapidViewPermissionCheck {
    public boolean check(RapidView view) {
        return true
    }
}

@JiraAgileBean RapidViewManager rapidViewManager
SearchRequestManager srm = ComponentAccessor.getComponent(SearchRequestManager)

def sb = new StringBuilder()
if (isPreview == true) {
    sb.append("<b>Please, note it works as preview. For execute change variable isPreview = true </b><br/><br/>\n")
} else {
    sb.append("<b>Please, note it works in execute mode</b><br/><br/>\n")
}


sb.append("<b>Board id</b> - Name - <b> Owner </b><br />\n")
rapidViewManager.getAll(new NoCheck()).value.each { b ->
    if (srm.getSearchRequestById(b.savedFilterId) == null) {
        if (!isPreview) {
            def res = rapidViewManager.delete(b)
        }
        sb.append("${b.id} - ${b.name} - ${b.owner}<br />\n")
    }
}

return sb.toString()