/*
    Get a Scriptrunner jobs in a table
 */
import com.atlassian.jira.component.ComponentAccessor
import groovy.sql.Sql
import groovy.json.JsonSlurper
import org.ofbiz.core.entity.ConnectionFactory
import org.ofbiz.core.entity.DelegatorInterface
import java.sql.Connection


def delegator = (DelegatorInterface) ComponentAccessor.getComponent(DelegatorInterface)
String helperName = delegator.getGroupHelperName("default")


def sqlStmt = /SELECT t."SETTING" FROM "AO_4B00E6_STASH_SETTINGS" t WHERE t."KEY" = 'scheduled_jobs'/


Connection conn = ConnectionFactory.getConnection(helperName)
Sql sql = new Sql(conn)
def result = ""

try {
    result = sql.firstRow(sqlStmt)[0]
} finally {
    sql.close()
}

String jobJson = result


def rawJobs = new JsonSlurper().parseText(jobJson)


def retJobs = rawJobs.collect { rawJob ->
    def retJob = [:]
    retJob.id = rawJob.id
    retJob.note = rawJob.FIELD_NOTES
    retJob.interval = rawJob.FIELD_INTERVAL
    retJob.schedulteType = rawJob.scheduleType
    retJob.jobType = rawJob['@class'].tokenize('.').last()
    retJob.jql = rawJob.FIELD_JQL_QUERY
    retJob.wfaction = rawJob.FIELD_ACTION
    retJob.disabled = rawJob.disabled
    retJob //return the new map
}

def sb = new StringBuilder()
sb.append("<table>")
sb.append("<tr>")
sb.append("<th>Job Type</th>")
sb.append("<th>Interval</th>")
sb.append("<th>Description</th>")
sb.append("<th>JQL</th>")
sb.append("<th>Workflow action</th>")
sb.append("<th>InActive</th>")
sb.append("<th>UUID</th>")
sb.append("</tr>")

retJobs.each {
    sb.append("<tr>")
    sb.append("<td>" + it.jobType + "</td>")
    sb.append("<td>" + it.interval + "</td>")
    sb.append("<td>" + it.note + "</td>")
    sb.append("<td>" + it.jql + "</td>")
    sb.append("<td>" + it.wfaction + "</td>")
    sb.append("<td>" + it.disabled + "</td>")
    sb.append("<td>" + it.id + "</td>")
    sb.append("</tr>")
}
sb.append("</table>")
return sb.toString()