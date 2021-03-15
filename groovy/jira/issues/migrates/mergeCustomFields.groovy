/*
*  That script just migrate and merge 2 custom fields with the same types
*  This script works without notification and as a service
*
* */

import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.CustomFieldManager
import com.atlassian.jira.issue.fields.CustomField
import com.atlassian.jira.issue.IssueManager
import com.atlassian.jira.issue.Issue
import com.atlassian.jira.issue.MutableIssue
import org.apache.log4j.Logger
import org.apache.log4j.Level
import com.atlassian.jira.event.type.*
import com.atlassian.jira.util.ImportUtils
import com.atlassian.jira.issue.ModifiedValue
import com.atlassian.jira.issue.util.DefaultIssueChangeHolder
import com.atlassian.jira.issue.index.IssueIndexingService
import com.atlassian.jira.bc.issue.search.SearchService;
import com.atlassian.jira.bc.issue.search.SearchService.ParseResult
import com.atlassian.jira.web.bean.PagerFilter

def log = Logger.getLogger("com.gonchik.scripts.groovy.migrate.values")
log.setLevel(Level.DEBUG)

def sourceFieldName = "External issue ID 3"
def destFieldName = "External issue ID"
String jqlSearch = ' "${sourceFieldName}" is not EMPTY'
boolean cleanSourceField = false

CustomFieldManager fieldManager = ComponentAccessor.getCustomFieldManager()
CustomField sourceCustomField = fieldManager.getCustomFieldObjectByName("${sourceFieldName}")
CustomField destinationCustomField = fieldManager.getCustomFieldObjectByName("${destFieldName}")
def issueIndexingService = ComponentAccessor.getComponent(IssueIndexingService.class)
def output = new StringBuilder()
def user = ComponentAccessor.getJiraAuthenticationContext().getLoggedInUser()
IssueManager issueManager = ComponentAccessor.getIssueManager()
SearchService searchService = ComponentAccessor.getComponent(SearchService.class)
SearchService.ParseResult parseResult = searchService.parseQuery(user, jqlSearch)
if (!parseResult.isValid()) {
    log.debug("JQL is not correct")
    output.append("JQL is not correct")
    return output.toString()
}

def searchResult = searchService.search(user, parseResult.getQuery(), PagerFilter.getUnlimitedFilter())
def issues = searchResult.results.collect { issueManager.getIssueObject(it.id) }

for (issue in issues) {
    log.debug("Before change is ${issue.getCustomFieldValue(destinationCustomField)} for ${issue.key}")
    output.append("Before change is ${issue.getCustomFieldValue(destinationCustomField)} for ${issue.key}")
    //Transition issue by transition name and not by transition id, very useful for queries with issues with different workflows
    def value = sourceCustomField.getValue(issue)
    MutableIssue issueToUpdate = (MutableIssue) issue
    destinationCustomField.updateValue(null, issueToUpdate, new ModifiedValue("", value), new DefaultIssueChangeHolder())
    // updates with history
    // issueToUpdate.setCustomFieldValue(destinationCustomField, value)
    // issueManager.updateIssue(user, issueToUpdate, EventDispatchOption.DO_NOT_DISPATCH, false)
    if (cleanSourceField) {
        sourceCustomField.updateValue(null, issueToUpdate, new ModifiedValue(null, null), new DefaultIssueChangeHolder())
    }

    boolean wasIndexing = ImportUtils.isIndexIssues()
    ImportUtils.setIndexIssues(true)
    log.warn("Reindex issue ${issue.key} ${issue.id}")
    issueIndexingService.reIndex(issue)
    ImportUtils.setIndexIssues(wasIndexing)
    log.debug("After change is ${issue.getCustomFieldValue(destinationCustomField)} for ${issue.key}")
    output.append("After change is ${issue.getCustomFieldValue(destinationCustomField)} for ${issue.key}")
}


return output.toString()