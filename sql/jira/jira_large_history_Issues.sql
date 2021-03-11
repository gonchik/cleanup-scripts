-- find top 100 with large history issues
-- https://jira.atlassian.com/browse/JRASERVER-66251
-- Reindexing large number of issues with a lot of change history can cause an OOME

select concat(p.pkey,'-',ji.issuenum) as issue, count(ji.id)
from changeitem ci
         join changegroup cg on cg.id = ci.groupid
         join jiraissue ji on cg.issueid = ji.id
         join project p on p.id = ji.project
group by ji.issuenum,p.pkey
order by count(ji.id) desc
limit 100;

-- MS SQL request
/*
SELECT TOP 100  concat(p.pkey,'-',ji.issuenum) AS issue, count(ji.id)
FROM changeitem ci
         JOIN changegroup cg ON cg.id = ci.groupid
         JOIN jiraissue ji ON cg.issueid = ji.id
         JOIN project p ON p.id = ji.project
GROUP BY ji.issuenum,p.pkey
ORDER BY count(ji.id) DESC;
*/