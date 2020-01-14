-- find top 100 with large history issues
-- https://jira.atlassian.com/browse/JRASERVER-66251

select concat(p.pkey,'-',ji.issuenum) as issue, count(ji.id)
from changeitem ci
         join changegroup cg on cg.id = ci.groupid
         join jiraissue ji on cg.issueid = ji.id
         join project p on p.id = ji.project
group by ji.issuenum,p.pkey order by count(ji.id) DESC
limit 100;