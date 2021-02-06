boolean isPreview = false
// remove inactive users from role
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.bc.user.search.UserSearchService
import com.atlassian.jira.bc.user.search.UserSearchParams
import com.atlassian.jira.user.ApplicationUser
import com.atlassian.jira.util.SimpleErrorCollection
import com.atlassian.jira.bc.projectroles.ProjectRoleService
import com.atlassian.jira.project.Project
import org.apache.log4j.Logger
import org.apache.log4j.Level
import com.atlassian.jira.user.preferences.UserPreferencesManager
import com.atlassian.core.user.preferences.Preferences
import com.atlassian.jira.user.preferences.PreferenceKeys
import com.atlassian.jira.security.groups.GroupManager

def log = Logger.getLogger("com.gonchik.scripts.groovy.deleteAutoWatchPreferencesForExternalUsers")
log.setLevel(Level.DEBUG)


ComponentAccessor.getGroupManager().getUsersInGroup('external-users').each{
    ApplicationUser user = it
    UserPreferencesManager userPreferencesManager = ComponentAccessor.getUserPreferencesManager();
    Preferences preferences = userPreferencesManager.getExtendedPreferences(user);
    try {
        if(!isPreview){
            preferences.setBoolean(PreferenceKeys.USER_AUTOWATCH_DISABLED, true);
        }
    } catch (Exception e) {
        log.error(e);
    }
}