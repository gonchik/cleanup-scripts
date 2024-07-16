/*
-- SQL equivalents for Jira server's workflow integrity checks
-- Execute the Administration -> System -> Integrity Checker
-- Execute the Administration -> System -> Indexing
*/


-- https://confluence.atlassian.com/jirakb/how-to-run-the-workflow-integrity-checks-in-sql-658179102.html
-- https://jira.atlassian.com/browse/JRASERVER-4241
-- check Workflow Entry States are Correct
SELECT jiraissue.id issue_id,
       jiraissue.workflow_id,
       OS_WFENTRY.*
FROM jiraissue
         JOIN OS_WFENTRY
              ON jiraissue.workflow_id = OS_WFENTRY.id
WHERE OS_WFENTRY.state is null
   OR OS_WFENTRY.state = 0;

-- fix by
-- UPDATE OS_WFENTRY SET state = 1 WHERE id in (OS_WFENTRY_ID_VALUES)

-- alternative query with prepared UP request
SELECT concat( 'UPDATE OS_WFENTRY SET state = 1 WHERE id in (',
       jiraissue.workflow_id, ');')
FROM   jiraissue
JOIN   OS_WFENTRY
ON     jiraissue.workflow_id = OS_WFENTRY.id
WHERE  OS_WFENTRY.state IS NULL
OR     OS_WFENTRY.state = 0;


-- check issue number null tickets
SELECT id, issuenum, project
FROM jiraissue
WHERE project is null;

-- fix that null ticket
-- DELETE FROM jiraissue WHERE project IS NULL;