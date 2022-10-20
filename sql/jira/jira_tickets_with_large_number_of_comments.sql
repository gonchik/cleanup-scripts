-- find tickets with large number of comments
-- https://jira.atlassian.com/browse/JRASERVER-66251

SELECT concat(p.pkey,'-',i.issuenum) as issue, count(i.id)
FROM jiraaction a, jiraissue i, project p
WHERE i.project = p.id and i.id = a.issueid
GROUP BY p.pkey,i.issuenum
HAVING count(i.id) > 100
ORDER BY count (i.id) DESC
limit 100;