./*
    SQL equivalents for Jira server's workflow integrity checks
    Jira Issues with Null Status
    link: https://confluence.atlassian.com/jirakb/sql-equivalents-for-jira-server-s-workflow-integrity-checks-658179102.html
*/

SELECT ji.id,
       ji.issuenum,
       ji.issuestatus,
       ji.project,
       ji.issuetype,
       currentStep.step_id
FROM   jiraissue ji
JOIN   OS_CURRENTSTEP currentStep
       ON ji.workflow_id = currentStep.entry_id
WHERE  ji.issuestatus is null;


-- And can be fixed by:
UPDATE jiraissue
SET    issuestatus = (SELECT state
                      FROM   OS_WFENTRY
                      WHERE  id = workflow_id)
WHERE  issuestatus is null;