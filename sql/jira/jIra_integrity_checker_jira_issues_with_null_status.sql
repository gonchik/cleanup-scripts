-- SQL equivalents for Jira server's workflow integrity checks
-- Jira Issues with Null Status
-- https://confluence.atlassian.com/jirakb/sql-equivalents-for-jira-server-s-workflow-integrity-checks-658179102.html

SELECT jiraissue.id,
       jiraissue.issuenum,
       jiraissue.issuestatus,
       jiraissue.project,
       jiraissue.issuetype,
       currentStep.step_id
FROM   jiraissue jiraissue
JOIN   OS_CURRENTSTEP currentStep
       ON jiraissue.workflow_id = currentStep.entry_id
WHERE  jiraissue.issuestatus is null;


-- And can be fixed by:
UPDATE jiraissue
SET    issuestatus = (select state
                      from   OS_WFENTRY
                      where  id = workflow_id)
WHERE  issuestatus is null;