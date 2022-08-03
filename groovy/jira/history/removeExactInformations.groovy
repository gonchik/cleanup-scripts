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

String jqlSearch = '''key in (HR-659651
,HR-659448
,HR-633219
,HR-616282
,HR-615716
,HR-824547
,HR-621331
,HR-621324
,BS-66517
,BSC-3114
,HRBS-1764
,HR-646644
,BSC-3436
,BSC-2742
,SERV-2093
,SERV-880
,SERV-1901
,SERV-1265
,FINCONT-20890
,BS-113279
,SERV-2848
,BS-114661
,SERV-603
,SERV-2398
,HR-622240
,HR-631723
,SERV-757
,BS-36305
,SERV-1520
,BSC-3779
,FINCONT-14829
,HRBS-1354
,FINCONT-18256
,SERV-3018
,O2C-134187
,HR-615694
,HRBS-1660
,FINCONT-27864
,SERV-1738
,FINCONT-16031
,HR-615955
,O2C-113013
,SERV-2663
,FINCONT-78825
,BS-53906
,BS-53898
,HRBS-991
,HR-617940
,FINCONT-35099
,HR-621339
,ES-7
,BS-54458
,BS-54486
,BS-54642
,FINCONT-40131
,O2C-186527
,FINCONT-18358
,FINCONT-18269
,FINCONT-33466
,FINCONT-41930
,FINCONT-102162
,FINCONT-40588
,FINCONT-76805
,P2P-857
,O2C-274336
,FINCONT-73584
,FINCONT-39716
,BSC-2278
,HRBS-2235
,BS-30504
,HR-544079
,HRBS-1363
,FINCONT-52568
,FINCONT-92868
,FINCONT-124149
,HR-825093
,HR-620709
,HR-795558
,DOI-20
,HR-825182
,BS-126638
,HR-827152
,BS-64531
,FINCONT-36532
,HR-823680
,HR-827716
,HR-827416
,P2P-176
,P2P-196
,HR-830236
,FINCONT-39552
,BS-64074
,FINPL-8174
,FINCONT-45583
,HR-613528
,HR-819776
,HRBS-1323
,HR-821058
,P2P-201
,BS-132614) '''

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
