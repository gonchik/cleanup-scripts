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

def makeAllFiltersGlobal() {
    ApplicationUser user = ComponentAccessor.getJiraAuthenticationContext().getLoggedInUser()
    SearchRequestManager srm = ComponentAccessor.getComponent(SearchRequestManager.class)

    srm.visitAll(new Visitor<SearchRequestEntity>() {

        void visit(SearchRequestEntity e) {

            SearchRequest sr = srm.getSearchRequestById(e.id)
            Set<SharePermission> permissionsSet = new HashSet<SharePermission>(
                    sr.getPermissions().getPermissionSet()
            )
            permissionsSet.add(new SharePermissionImpl(Name.GLOBAL, null, null))
            sr.setPermissions(new SharePermissions(permissionsSet))

            srm.update(sr)
        }
    })
}

makeAllFiltersGlobal()