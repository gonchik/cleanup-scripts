/*
-- Execute the Administration -> System -> Integrity Checker
-- Execute the Administration -> System -> Indexing
*/


-- https://confluence.atlassian.com/jirakb/how-to-run-the-workflow-integrity-checks-in-sql-658179102.html
-- https://jira.atlassian.com/browse/JRASERVER-4241
-- check Workflow Entry States are Correct
SELECT jiraissue.id issue_id,
       jiraissue.workflow_id,
       OS_WFENTRY.*
FROM   jiraissue
JOIN   OS_WFENTRY
ON     jiraissue.workflow_id = OS_WFENTRY.id
WHERE  OS_WFENTRY.state IS NULL
OR     OS_WFENTRY.state = 0;

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


-- Jira Issues with Null Status
SELECT jiraissue.id,
       jiraissue.issuenum,
       jiraissue.issuestatus,
       jiraissue.project,
       jiraissue.issuetype,
       currentStep.step_id
FROM   jiraissue jiraissue
JOIN   OS_CURRENTSTEP currentStep
ON     jiraissue.workflow_id = currentStep.entry_id
WHERE  jiraissue.issuestatus IS NULL;

-- And can be fixed by:
UPDATE jiraissue
SET    issuestatus = (SELECT state
                      FROM   OS_WFENTRY
                      WHERE  id = workflow_id)
WHERE  issuestatus IS NULL;
