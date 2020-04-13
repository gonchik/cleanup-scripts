def isPreview = false
import com.atlassian.jira.user.ApplicationUser;
import com.atlassian.jira.user.UserHistoryItem;
import com.atlassian.jira.user.UserHistoryManager;
import com.atlassian.jira.component.ComponentAccessor;
import com.atlassian.jira.user.UserHistoryItem.*;
import com.atlassian.jira.bc.user.search.UserSearchService
import com.atlassian.jira.bc.user.search.UserSearchParams
import com.atlassian.jira.user.ApplicationUser
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupLastViewHistoryForInactiveUsers")
log.setLevel(Level.DEBUG)

// This script shows how to clean up the votes from inactive users
UserSearchService userSearchService = ComponentAccessor.getComponent(UserSearchService.class)
UserSearchParams userSearchParams = (new UserSearchParams.Builder()).allowEmptyQuery(true).includeActive(false).includeInactive(true).maxResults(100000).build()
def userHistoryManager = ComponentAccessor.getComponent(UserHistoryManager.class)
def sb = new StringBuilder()
for (ApplicationUser appUser : userSearchService.findUsers("", userSearchParams)) {
    List<UserHistoryItem> recentUserHistory = userHistoryManager.getHistory(UserHistoryItem.ASSIGNEE, appUser);
    if (!isPreview){
        userHistoryManager.removeHistoryForUser(appUser)
    }
    sb.append("${appUser.name}<br/>\n")
}
return sb.toString()

