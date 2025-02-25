boolean isPreview = true
/*
    Clean up the votes from inactive users
    Additional:  This script can be run from Jira -> Administration -> Add-ons -> Script Console
    Tested Environment: Jira 8.20.5, 8.13.3, 9.12.5
    Contribution: Gonchik Tsymzhitov
 */
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.bc.user.search.UserSearchService
import com.atlassian.jira.bc.user.search.UserSearchParams
import com.atlassian.jira.user.ApplicationUser
import com.atlassian.jira.issue.vote.VoteManager
import org.apache.log4j.Logger
import org.apache.log4j.Level

def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupVotesForInactiveUsers")
log.setLevel(Level.DEBUG)

// This script shows how to clean up the votes from inactive users
UserSearchService userSearchService = ComponentAccessor.getComponent(UserSearchService.class)
UserSearchParams userSearchParams = (new UserSearchParams.Builder()).allowEmptyQuery(true).includeActive(false).includeInactive(true).maxResults(100000).build()
VoteManager voteManager = ComponentAccessor.getComponent(VoteManager.class)
def sb = new StringBuilder()
for (ApplicationUser appUser : userSearchService.findUsers("", userSearchParams)) {
    ApplicationUser userToRemove = appUser
    if (!isPreview) {
        voteManager.removeVotesForUser(userToRemove)
    }
    sb.append("${userToRemove.name}<br/>\n")
}
return sb.toString()