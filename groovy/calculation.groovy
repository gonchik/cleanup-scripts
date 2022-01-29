import com.atlassian.jira.issue.util.DefaultIssueChangeHolder
import com.atlassian.jira.issue.ModifiedValue
import com.atlassian.jira.issue.CustomFieldManager
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.Issue
import java.lang.Math
import com.atlassian.jira.web.bean.PagerFilter
import com.atlassian.jira.issue.IssueManager
import com.atlassian.jira.issue.link.IssueLinkManager
import com.atlassian.jira.config.SubTaskManager
import com.atlassian.jira.issue.fields.CustomField
import com.atlassian.jira.issue.status.Status
import com.atlassian.jira.issue.status.category.StatusCategory
import com.atlassian.jira.issue.util.DefaultIssueChangeHolder
import com.atlassian.jira.issue.index.IssueIndexingService
import com.atlassian.jira.bc.issue.search.SearchService
import com.atlassian.jira.bc.issue.search.SearchService.ParseResult
import org.apache.log4j.Logger
import org.apache.log4j.Level

IssueLinkManager issueLinkManager = ComponentAccessor.getIssueLinkManager();
CustomFieldManager customFieldManager = ComponentAccessor.getCustomFieldManager()
SubTaskManager subTaskManager = ComponentAccessor.getSubTaskManager();
def user = ComponentAccessor.getJiraAuthenticationContext().getLoggedInUser()
IssueManager issueManager = ComponentAccessor.getIssueManager()
String jqlSearch = /project = PL AND Division = Payments AND (type = Initiative OR type in ("Work Package", Milestone) AND Quarter = "Q1 2022")  OR issueFunction in linkedIssuesOfAllRecursiveLimited("project = PL and type='Work Package' and Quarter = 'Q1 2022' and Division = Payments ", 1)/
// jqlSearch ="key=PL-4958"
SearchService searchService = ComponentAccessor.getComponent(SearchService.class)
SearchService.ParseResult parseResult = searchService.parseQuery(user, jqlSearch)

// does JQL valid?
if (!parseResult.isValid()) {
    return "Please, validate a JQL"
}
def log = Logger.getLogger("feature.progress")
log.setLevel(Level.DEBUG)
def searchResult = searchService.search(user, parseResult.getQuery(), PagerFilter.getUnlimitedFilter())
def issues = searchResult.results.collect { issueManager.getIssueObject(it.id) }
for (issue in issues) {
    // log.debug issue.key
    Issue story
    Double percentage = 0
    int numberOfTickets = 1
    float sumOfProgress = getProgressInfo(issue)
    int value = 0
    int misses = 0
    //Loop through all linked issues associated with this ticket.
    issueLinkManager.getOutwardLinks(issue.id).each { issueLink ->
        def linkTypeName = issueLink.issueLinkType.getName()
        // log.debug linkTypeName
        if (linkTypeName == "Hierarchy [Gantt]" ||
                linkTypeName == "Allocated" || linkTypeName == "Contains" || linkTypeName == "Contains" || linkTypeName == "Hierarchy link (WBSGantt)" ||
                linkTypeName == "Epic-Story Link" || linkTypeName == "Parent-Child Link") {
            story = issueLink.destinationObject
            issueStatusCategory = story.getStatus().getStatusCategory().getName();
            numberOfTickets += 1
            value = getProgressInfo(story)
            sumOfProgress += value
            if (value == 0) {
                misses += 1
            }
            // log.debug "№ ${numberOfTickets} Procent = ${value} status = ${story.status.name}"
        }
    }

    // log.debug "${numberOfTickets} ${sumOfProgress} ${misses}"
    if (numberOfTickets > 0 && sumOfProgress > 0) {
        percentage = (sumOfProgress / numberOfTickets).round(1)
    } else {
        percentage = 0.0
    }

    autoProgress = customFieldManager.getCustomFieldObjectByName("Automatic progress")
    autoProgress.updateValue(null, issue, new ModifiedValue(null, percentage), new DefaultIssueChangeHolder())
    log.debug "${issue.key} - ${issue.status.name} - ${percentage}"

    generalProgress = customFieldManager.getCustomFieldObjectByName("Progress %")
    def oldValueOfProgress = generalProgress.getValue(issue)
    if (percentage > 0 && (oldValueOfProgress == null || oldValueOfProgress == 0)) {
        generalProgress.updateValue(null, issue, new ModifiedValue(null, percentage), new DefaultIssueChangeHolder())
    }
    ComponentAccessor.getComponent(IssueIndexingService.class).reIndex(issue)
}


int getProgressInfo(Issue issue) {
    def weightMapping = [
            "Not completed"             : 0,
            "New"                       : 0,
            "Refused"                   : 0,
            "Declined"                  : 0,
            "Cancelled"                 : 0,
            "Rejected"                  : 0,
            "TODO"                      : 0,
            "Backlog"                   : 10,
            "In Progress"               : 50,
            "To Do"                     : 0,
            "Resolved"                  : 90,
            "Open"                      : 5,
            "Approved"                  : 5,
            "Planning"                  : 10,
            "Confirmed"                 : 10,
            "Pending"                   : 10,
            "BI Acceptance"             : 10,
            "Approval & Review"         : 10,
            "Evaluation"                : 15,
            "Alignment"                 : 20,
            "Evaluation"                : 30,
            "Preparation"               : 40,
            "3rd Party"                 : 40,
            "In code review"            : 40,
            "Data gathering"            : 50,
            "Partially completed"       : 50,
            "Analysing"                 : 67,
            "Review"                    : 60,
            "Support Action Required"   : 80,
            "Ready for testing"         : 80,
            "Ready for verification"    : 60,
            "Reporting"                 : 83,
            "Waiting for Client"        : 90,
            "Post analysis and Feedback": 90,
            "Waiting for customer"      : 90,
            "Closed"                    : 100,
            "Completed"                 : 100,
            "Done"                      : 100,
            "In Use"                    : 100,
            "Disposed"                  : 100,
            "Analysis"                  : 20,
            "Released"                  : 90,
            "On Prod"                   : 100,

    ]
    def statusName = issue.status.name
    def statusCategoryName = issue.getStatus().getStatusCategory().getName()
    if (weightMapping.containsKey(statusName)) {
        return weightMapping.get(statusName)
    }
    if (statusCategoryName == "New") {
        return 100
    }
    if (statusCategoryName == "In Progress") {
        return 50
    }
    if (statusCategoryName == "Complete") {
        return 0
    }
    return 0
}