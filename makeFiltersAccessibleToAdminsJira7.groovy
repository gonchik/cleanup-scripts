// https://kb.botronsoft.com/x/gIJk
import com.atlassian.crowd.embedded.api.User
import com.atlassian.jira.user.ApplicationUser
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.search.SearchRequest
import com.atlassian.jira.issue.search.SearchRequestEntity
import com.atlassian.jira.issue.search.SearchRequestManager
import com.atlassian.jira.sharing.SharePermission
import com.atlassian.jira.sharing.SharePermissionImpl
import com.atlassian.jira.sharing.SharedEntity.SharePermissions
import com.atlassian.jira.sharing.type.ShareType.Name
import com.atlassian.jira.util.Visitor

// This function will share with the group "jira-administrators" th filter with ID "filterId"
def makeFilterAccessibleToAdmins(long filterId) {
    ApplicationUser user = ComponentAccessor.getJiraAuthenticationContext().getLoggedInUser()
    SearchRequestManager srm = ComponentAccessor.getComponent(SearchRequestManager.class)

    SearchRequest sr = srm.getSearchRequestById(filterId)
    Set<SharePermission> permissionsSet = new HashSet<SharePermission>(
            sr.getPermissions().getPermissionSet()
    )
    permissionsSet.add(new SharePermissionImpl(null, Name.GROUP, "jira-administrators", null))
    sr.setPermissions(new SharePermissions(permissionsSet))

    srm.update(sr)
}

// Pass the ID of the filter you want to update
makeFilterAccessibleToAdmins(FILTERIDHERE)