boolean isPreview = false
// Find unassociated issue types to projects
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.avatar.AvatarService
import org.apache.log4j.Logger
import org.apache.log4j.Level
import com.atlassian.jira.avatar.Avatar;
import com.atlassian.jira.avatar.AvatarManager
import com.atlassian.jira.user.ApplicationUser
import com.atlassian.jira.bc.user.search.UserSearchService
import com.atlassian.jira.bc.user.search.UserSearchParams
import com.atlassian.jira.user.util.UserManager
import com.atlassian.jira.icon.IconType

def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupUnAssociatedIssueType")
log.setLevel(Level.DEBUG)

def sb = new StringBuilder()

if (isPreview) {
    sb.append("<b>Please, note it works as preview. For execute change variable isPreview = true </b><br/><br/>\n")
} else {
    sb.append("<b>Please, note it works in execute mode</b><br/><br/>\n")
}
AvatarService avatarService = ComponentAccessor.getAvatarService()
AvatarManager avatarManager = ComponentAccessor.getAvatarManager()


def currentUser = ComponentAccessor.getJiraAuthenticationContext().getLoggedInUser()


UserSearchService userSearchService = ComponentAccessor.getComponent(UserSearchService.class)
UserSearchParams userSearchParams = (new UserSearchParams.Builder()).allowEmptyQuery(true).includeActive(true).includeInactive(true).maxResults(100000).build()

for (ApplicationUser owner : userSearchService.findUsers("", userSearchParams)) {
    def activeAvatar = avatarService.getAvatar(currentUser, owner)

    orphanedAvatars = avatarManager.getCustomAvatarsForOwner(IconType.USER_ICON_TYPE, owner.key)

    log.debug(owner)
    for (it in orphanedAvatars) {
        def orphanedAvatar = it
        if (activeAvatar.id == orphanedAvatar.id) {
            log.info("Skip active avatar")
        } else {
            log.info("Remove Avatar with ID ${orphanedAvatar.getId()}");
            ComponentAccessor.getAvatarManager().delete(orphanedAvatar.getId(), true);
        }
    }

}
return sb.toString()