-- find tickets with large number of comments
-- https://jira.atlassian.com/browse/JRASERVER-66251

select concat(p.pkey,'-',i.issuenum) as issue, count(i.id)
from jiraaction a, jiraissue i, project p
where i.project = p.id and i.id = a.issueid
group by p.pkey,i.issuenum
order by count (i.id) desc
limit 100;