/* This script works without notification and as a service
*  clean change items, it helps for programmatically create cases */

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
import com.atlassian.jira.bc.issue.search.SearchService
import com.atlassian.jira.bc.issue.search.SearchService.ParseResult
import com.atlassian.jira.web.bean.PagerFilter
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.changehistory.ChangeHistoryManager
import com.atlassian.jira.issue.changehistory.ChangeHistory
import com.atlassian.jira.entity.property.JsonEntityPropertyManager
import com.atlassian.jira.entity.Entity
import com.atlassian.jira.entity.property.EntityPropertyType
import com.atlassian.jira.ofbiz.OfBizDelegator


final def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupChangeItems")
log.setLevel(Level.DEBUG)

String jqlSearch = '''key in (HR-659651) '''

def user = ComponentAccessor.getJiraAuthenticationContext().getLoggedInUser()
IssueManager issueManager = ComponentAccessor.getIssueManager()
SearchService searchService = ComponentAccessor.getComponent(SearchService.class)
SearchService.ParseResult parseResult = searchService.parseQuery(user, jqlSearch)

def issueIndexingService = ComponentAccessor.getComponent(IssueIndexingService.class)

// does JQL valid?
if (!parseResult.isValid()) {
    return "Please, validate a JQL"
}

def searchResult = searchService.search(user, parseResult.getQuery(), PagerFilter.getUnlimitedFilter())
def issues = searchResult.results.collect { issueManager.getIssueObject(it.id) }

final changeHistoryManager = ComponentAccessor.changeHistoryManager
JsonEntityPropertyManager jsonEntityPropertyManager =
        ComponentAccessor.getComponent(JsonEntityPropertyManager)
OfBizDelegator ofBizDelegator = ComponentAccessor.getOfBizDelegator()

fieldsToRemove = ['Reason (text)']

for (issue in issues) {
    // changeHistoryManager.removeAllChangeItems(issue)
    log.debug("Removing change items for ${issue.key}")

    List<ChangeHistory> history = changeHistoryManager.getChangeHistories(issue)
    history.each { ChangeHistory ch ->
        Boolean allDeleted = null
        ch.changeItems.each { it ->
            // log.debug it
            Long changeItemId = it.get("id")
            String field = it.get("field")
            if (fieldsToRemove.contains(field)
                    || (it.field == 'status' && it.oldvalue == '3' && it.newvalue == '3')
                    || (it.field == 'status' && it.oldvalue == '10004' && it.newvalue == '10004')
                    || (it.field == 'Comment' && it.oldvalue == '[^Руководство по обеспечению безопасности.pdf]' && it.newvalue == null)
                    || (it.field == 'Attachment' && it.oldvalue == 'Руководство по обеспечению безопасности.pdf' && it.newvalue == null)
            ) {
                if (allDeleted == null) {
                    allDeleted = true
                }
                ofBizDelegator.removeByAnd(Entity.Name.CHANGE_ITEM,
                        [id: changeItemId].asImmutable())
            } else {
                allDeleted = false
            }
        }

        if (allDeleted) {
            ofBizDelegator.removeByAnd(Entity.Name.CHANGE_GROUP,
                    [id: ch.id].asImmutable())
            jsonEntityPropertyManager.deleteByEntity(
                    EntityPropertyType.CHANGE_HISTORY_PROPERTY.getDbEntityName(),
                    ch.id)
        }
    }
    log.debug("Removed change items for ${issue.key}")
}
