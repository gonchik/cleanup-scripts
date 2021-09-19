-- Detect duplicate issue keys in Jira
-- https://confluence.atlassian.com/jirakb/how-to-fix-duplicate-issue-keys-in-jira-1062243102.html

select p.id as "Project ID",
        p.pkey as "Project Key",
        a.issuenum as "Issue Num",
        a.id as "Issue A ID",
        b.id as "Issue B ID"
from jiraissue a
join jiraissue b on a.issuenum = b.issuenum and a.project = b.project and a.id < b.id
join project p on a.project = p.id
where a.id is not null;



-- fix
update jiraissue
set issuenum = (select (max(issuenum) + 1)
from jiraissue where project = <Project ID>)
where id = <Issue B ID>;
