-- SQL to identify issues with large worklog history
-- https://jira.atlassian.com/browse/JRASERVER-45903
select concat(p.pkey,'-',i.issuenum) as issue, count(a.id)
from worklog a, jiraissue i, project p
where i.project = p.id and i.id = a.issueid
group by p.pkey,i.issuenum
having count(a.id) > 100
order by count (a.id) desc
limit 100;