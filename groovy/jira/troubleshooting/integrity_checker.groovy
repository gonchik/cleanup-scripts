/* This script just wrapper of sql scripts
 https://github.com/gonchik/cleanup-scripts/blob/master/sql/jira/jira_integrity_checker.sql
*/

import com.atlassian.jira.component.ComponentAccessor
import org.apache.log4j.Logger
import org.apache.log4j.Level
import com.atlassian.jira.issue.util.DefaultIssueChangeHolder
import groovy.sql.Sql
import org.ofbiz.core.entity.ConnectionFactory
import org.ofbiz.core.entity.DelegatorInterface
import java.sql.Connection


def log = Logger.getLogger("com.gonchik.scripts.groovy.troubleshooting")
log.setLevel(Level.DEBUG)

def isPreview = false
def rowIds = reviewIt()
for (row in rowIds){
    if (!isPreview){
        log.debug("Executing the state change query")
        makeUpdate(row)
    }
}

def reviewIt() {
    def delegator = (DelegatorInterface) ComponentAccessor.getComponent(DelegatorInterface)
    String helperName = delegator.getGroupHelperName("default")

    def sqlStmt = """
		SELECT jiraissue.id issue_id,
               jiraissue.workflow_id,
               OS_WFENTRY.*
        FROM   jiraissue
        JOIN   OS_WFENTRY
        ON     jiraissue.workflow_id = OS_WFENTRY.id
        WHERE  OS_WFENTRY.state IS NULL
        OR     OS_WFENTRY.state = 0;
	"""
    Connection conn = ConnectionFactory.getConnection(helperName)
    Sql sql = new Sql(conn)
    try {
        rows = sql.rows(sqlStmt)
    } finally {
        sql.close()
    }
    def result = []
    for (def row in rows){
        log.debug row
        result.add(row[2])
    }
    return result
}

def makeUpdate(def wfEntryId) {
    if (wfEntryId == null) {
        return
    }
    def delegator = (DelegatorInterface) ComponentAccessor.getComponent(DelegatorInterface)
    String helperName = delegator.getGroupHelperName("default")

    def sqlStmt = """
		UPDATE OS_WFENTRY SET state = 1 WHERE 
        	${wfEntryId ? Sql.expand(" id = '$wfEntryId'") : Sql.expand("")}
        ;
	"""
    Connection conn = ConnectionFactory.getConnection(helperName)
    Sql sql = new Sql(conn)
    String result = ""
    try {
        result = sql.execute(sqlStmt)
    } finally {
        sql.close()
    }
    return result
}