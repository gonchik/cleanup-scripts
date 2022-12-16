/*
   SQL equivalents for Jira server's workflow integrity checks
   Execute the Administration -> System -> Integrity Checker
   Execute the Administration -> System -> Indexing
*/

/*
   Check Workflow Entry States are Correct
   link: https://confluence.atlassian.com/jirakb/how-to-run-the-workflow-integrity-checks-in-sql-658179102.html
   link: https://jira.atlassian.com/browse/JRASERVER-4241
*/
SELECT jiraissue.id issue_id,
       jiraissue.workflow_id,
       OS_WFENTRY.*
FROM   jiraissue
JOIN   OS_WFENTRY
    ON jiraissue.workflow_id = OS_WFENTRY.id
WHERE  OS_WFENTRY.state is null OR OS_WFENTRY.state = 0;

-- fix by
-- UPDATE OS_WFENTRY SET state = 1 WHERE id in (OS_WFENTRY_ID_VALUES);

/*
   That query will generate update queries
*/
SELECT concat( 'UPDATE OS_WFENTRY SET state = 1 WHERE id in (',
       jiraissue.workflow_id, ');')
FROM   jiraissue
JOIN   OS_WFENTRY
ON     jiraissue.workflow_id = OS_WFENTRY.id
WHERE  OS_WFENTRY.state is null
OR     OS_WFENTRY.state = 0;
