boolean isPreview = true

import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.permission.PermissionSchemeManager

PermissionSchemeManager permissionSchemeManager = ComponentAccessor.getPermissionSchemeManager()

def sb = new StringBuilder()

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