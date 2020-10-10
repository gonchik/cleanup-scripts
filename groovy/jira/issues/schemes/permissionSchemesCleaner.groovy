boolean isPreview = true
// This script for cleanup of unused permission schemes

import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.permission.PermissionSchemeManager

PermissionSchemeManager permissionSchemeManager = ComponentAccessor.getPermissionSchemeManager()

def sb = new StringBuilder()
if (isPreview) {
    sb.append("<b>Please, note it works as preview. For execute change variable isPreview = true </b><br/><br/>\n")
} else {
    sb.append("<b>Please, note it works in execute mode</b><br/><br/>\n")
}
permissionSchemeManager.getUnassociatedSchemes().each {
    try{
        if (!isPreview) {
            sb.append ("Deleting unused permission scheme: <b>${it.name}</b><br/>")
            def sId = Long.valueOf("${it.id}")
            permissionSchemeManager.deleteScheme(sId)
        } else {
            sb.append ("Unused permission scheme: <b>${it.name}</b><br/>")
        }
    }
    catch (Exception e) {
        sb.append("Error: " + e + "\n")
    }
}
return sb.toString()