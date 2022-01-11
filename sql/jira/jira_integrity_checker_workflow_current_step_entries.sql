-- SQL equivalents for Jira server's workflow integrity checks
-- Workflow current step entries
-- https://confluence.atlassian.com/jirakb/sql-equivalents-for-jira-server-s-workflow-integrity-checks-658179102.html

select concat(concat(P.pkey, '-'), I.issuenum)
from jiraissue I
         join project P on P.id = I.project
         left join OS_CURRENTSTEP C on C.entry_id = I.workflow_id
where C.id is null;


--
-- Running the query below will generate the inserts for all issues missing the valid workflow step entry:


select concat(concat('insert into os_currentstep values ((select max(id)+1 from os_currentstep),', workflow_id), ',1,0,'''',now(),null,null,''open'',null)')
from jiraissue
where workflow_id not in (select entry_id from OS_CURRENTSTEP);
