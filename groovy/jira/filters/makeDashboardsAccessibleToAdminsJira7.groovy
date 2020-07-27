// https://kb.botronsoft.com/x/moBk
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.portal.PortalPage
import com.atlassian.jira.portal.PortalPageManager
import com.atlassian.jira.sharing.SharePermission
import com.atlassian.jira.sharing.SharePermissionImpl
import com.atlassian.jira.sharing.SharedEntity.SharePermissions
import com.atlassian.jira.sharing.type.ShareType.Name
import com.atlassian.jira.util.collect.EnclosedIterable.Functions


def makeAllDashboardsGlobal(long dashboardId) {
	PortalPageManager ppm = ComponentAccessor.getComponent(PortalPageManager.class)
    
	PortalPage portalPage = ppm.getPortalPageById(dashboardId)
	Set<SharePermission> permissionsSet = new HashSet<SharePermission>(
		portalPage.getPermissions().getPermissionSet()
	)
	permissionsSet.add(new SharePermissionImpl(null, Name.GROUP, "jira-administrators", null))
	ppm.update(PortalPage.portalPage(portalPage).permissions(new SharePermissions(permissionsSet)).build())
}

makeAllDashboardsGlobal(DASHBOARDIDHERE)