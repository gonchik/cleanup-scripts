-- SQL equivalents for Jira server's workflow integrity checks
-- Jira Issues with Null Status
-- https://confluence.atlassian.com/jirakb/sql-equivalents-for-jira-server-s-workflow-integrity-checks-658179102.html

select jiraissue.id,
       jiraissue.issuenum,
       jiraissue.issuestatus,
       jiraissue.project,
       jiraissue.issuetype,
       currentStep.step_id
from   jiraissue jiraissue
join   OS_CURRENTSTEP currentStep
       on   jiraissue.workflow_id = currentStep.entry_id
where  jiraissue.issuestatus is null;


-- And can be fixed by:
update jiraissue
set    issuestatus = (select state
                      from   OS_WFENTRY
                      where  id = workflow_id)
where  issuestatus is null;