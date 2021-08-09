def isPreview = true
/*
    That script clean last view activity,
    just in case it was related to the performance degradation in Jira Service Desk and Jira Software for the 10k+
 */
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

def USERNAME = "test.user"

def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupLastViewHistoryForUser")
log.setLevel(Level.DEBUG)


// This script shows how to clean up the history items from inactive users
def userHistoryManager = ComponentAccessor.getComponent(UserHistoryManager.class)

def appUser = ComponentAccessor.getUserManager().getUserByName(USERNAME)
def sb = new StringBuilder()
if (appUser) {
    List<UserHistoryItem> recentUserHistory = userHistoryManager.getHistory(UserHistoryItem.ASSIGNEE, appUser);
    if (!isPreview) {
        userHistoryManager.removeHistoryForUser(appUser)
    }
    sb.append("${appUser.name}<br/>\n")
}
return sb.toString()

