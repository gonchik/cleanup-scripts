/*
-- Execute the Administration -> System -> Integrity Checker
-- Execute the Administration -> System -> Indexing
*/


-- https://confluence.atlassian.com/jirakb/how-to-run-the-workflow-integrity-checks-in-sql-658179102.html
-- https://jira.atlassian.com/browse/JRASERVER-4241
-- check Workflow Entry States are Correct
select jiraissue.id issue_id,
       jiraissue.workflow_id,
       OS_WFENTRY.*
from   jiraissue
join   OS_WFENTRY
       on   jiraissue.workflow_id = OS_WFENTRY.id
where  OS_WFENTRY.state is null
   or   OS_WFENTRY.state = 0;

-- fix by
-- UPDATE OS_WFENTRY SET state = 1 WHERE id in (OS_WFENTRY_ID_VALUES)

-- that query will generate update queries
select concat( 'UPDATE OS_WFENTRY SET state = 1 WHERE id in (',
       jiraissue.workflow_id, ');')
from   jiraissue
join   OS_WFENTRY
on     jiraissue.workflow_id = OS_WFENTRY.id
where  OS_WFENTRY.state is null
or     OS_WFENTRY.state = 0;
