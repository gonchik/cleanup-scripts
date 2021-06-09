import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.Issue
import com.atlassian.jira.issue.index.DefaultIndexManager
import com.atlassian.jira.issue.IssueManager
import org.slf4j.LoggerFactory
import org.slf4j.Logger

final Logger log = LoggerFactory.getLogger(this.getClass())


def issueId = 988672


final DefaultIndexManager defaultIndexManager = ComponentAccessor.getComponentOfType(DefaultIndexManager.class);
final IssueManager issueManager = ComponentAccessor.getIssueManager()


Issue targetIssue = issueManager.getIssueObject(issueId);
if (!targetIssue) {return;}
log.info(">>> Issue deindex started.");
defaultIndexManager.deIndex(targetIssue);
log.info(">>> Issue deindex completed successfully!");