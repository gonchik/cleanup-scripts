import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.crowd.embedded.ofbiz.SwitchingUserDao
import com.atlassian.jira.entity.Entity
import com.atlassian.jira.issue.Issue
import com.atlassian.jira.issue.IssueFactory
import com.atlassian.jira.issue.index.DefaultIndexManager
import com.atlassian.jira.ofbiz.FieldMap
import com.atlassian.jira.ofbiz.OfBizDelegator
import com.atlassian.jira.permission.GlobalPermissionKey
import com.atlassian.jira.security.GlobalPermissionManager
import com.atlassian.jira.security.JiraAuthenticationContext
import com.atlassian.jira.user.ApplicationUser
import org.ofbiz.core.entity.GenericValue
import org.slf4j.LoggerFactory
import org.slf4j.Logger

final Logger log = LoggerFactory.getLogger(this.getClass())


def issueId = 988672


final DefaultIndexManager defaultIndexManager = ComponentAccessor.getComponentOfType(DefaultIndexManager.class);
final SwitchingUserDao switchingUserDao = ComponentAccessor.getComponentOfType(SwitchingUserDao.class);
final JiraAuthenticationContext jiraAuthenticationContext = ComponentAccessor.getJiraAuthenticationContext();
final GlobalPermissionManager globalPermissionManager = ComponentAccessor.getComponentOfType(GlobalPermissionManager.class);
final IssueFactory issueFactory = ComponentAccessor.getComponentOfType(IssueFactory.class);
final OfBizDelegator delegator = ComponentAccessor.getOfBizDelegator();

ApplicationUser currentUser = jiraAuthenticationContext.getUser();
log.info("located switchingUserDao: " + switchingUserDao);
log.info("located globalPermissionManager: " + globalPermissionManager);
log.info("currentUser: " + currentUser);
boolean adminCheckPassed = globalPermissionManager.hasPermission(GlobalPermissionKey.ADMINISTER, currentUser);
if (!adminCheckPassed) {
    log.error(currentUser.toString() + " does not have admin rights, won't continue...");
    return;
}
log.info(currentUser + " is an admin, continuing...");

if (issueId == null) {
    log.error("issueId parameter does not exist. Call this page with ?issueId=xxxxx");
    return;
}
final GenericValue gv = delegator.makeValue(Entity.Name.ISSUE, new FieldMap("id", Long.valueOf(issueId)));
Issue targetIssue = issueFactory.getIssue(gv);

log.info(">>> Issue deindex started.");
defaultIndexManager.deIndex(targetIssue);
log.info(">>> Issue deindex completed successfully!");