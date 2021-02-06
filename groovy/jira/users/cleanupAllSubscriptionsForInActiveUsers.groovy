boolean isPreview = true
/*
    This script do cleanup of subscription for inactive users
    https://confluence.atlassian.com/jirakb/keep-receiving-subscription-emails-from-deleted-filters-314450232.html
 */

import com.atlassian.jira.bc.JiraServiceContextImpl
import com.atlassian.jira.bc.JiraServiceContext
import com.atlassian.jira.bc.filter.SearchRequestService
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.user.ApplicationUser
import com.atlassian.jira.bc.user.search.UserSearchService
import com.atlassian.jira.bc.user.search.UserSearchParams
import com.atlassian.jira.issue.subscription.SubscriptionManager
import org.apache.log4j.Logger
import org.apache.log4j.Level


def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupAllSubscriptionsForInActiveUsers")
log.setLevel(Level.DEBUG)

/**
 * Method to delete private filters
 */

// This script can be run from Jira -> Administration -> Add-ons -> Script Console
UserSearchService userSearchService = ComponentAccessor.getOSGiComponentInstanceOfType(UserSearchService.class)
UserSearchParams userSearchParams = (new UserSearchParams.Builder()).allowEmptyQuery(true).includeActive(false).includeInactive(true).maxResults(100000).build()
def subscriptionManager = 	ComponentAccessor.getOSGiComponentInstanceOfType(SubscriptionManager.class)


for (ApplicationUser appUser : userSearchService.findUsers("", userSearchParams)) {
    subscriptionManager.deleteSubscriptionsForUser(appUser)
}