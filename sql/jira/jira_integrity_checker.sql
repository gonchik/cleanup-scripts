/*
-- SQL equivalents for Jira server's workflow integrity checks
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
on     jiraissue.workflow_id = OS_WFENTRY.id
where  OS_WFENTRY.state is null
or     OS_WFENTRY.state = 0;

-- fix by
-- UPDATE OS_WFENTRY SET state = 1 WHERE id in (OS_WFENTRY_ID_VALUES)

/*
SELECT concat( 'UPDATE OS_WFENTRY SET state = 1 WHERE id in (',
       jiraissue.workflow_id, ');')
FROM   jiraissue
JOIN   OS_WFENTRY
ON     jiraissue.workflow_id = OS_WFENTRY.id
WHERE  OS_WFENTRY.state IS NULL
OR     OS_WFENTRY.state = 0;
*/



-- Jira is trying to do index recovery on invalid issue data coming from Lucene indexes
-- https://jira.atlassian.com/browse/JRASERVER-70248
-- check issue number null tickets
select id,issuenum,project from jiraissue where issuenum is null;

-- fix
delete from jiraissue where issuenum is null;

-- check issue number null tickets
select id,issuenum,project from jiraissue where project is null;

-- fix
-- delete FROM jiraissue WHERE project IS NULL;