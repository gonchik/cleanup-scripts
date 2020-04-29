boolean isPreview = true

import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.notification.NotificationSchemeManager

NotificationSchemeManager notificationSchemeManager = ComponentAccessor.getNotificationSchemeManager()

def sb = new StringBuilder()

notificationSchemeManager.getUnassociatedSchemes().each {
    try {
        if (!isPreview) {
            sb.append("Deleting unused notification scheme: <b>${it.name}</b><br/>")
            def sId = Long.valueOf("${it.id}")
            notificationSchemeManager.deleteScheme(sId)
        } else {
            sb.append("Unused notification scheme: <b>${it.name}</b><br/>")
        }
    }
    catch (Exception e) {
        sb.append("Error: " + e + "\n")
    }
}

return sb.toString()