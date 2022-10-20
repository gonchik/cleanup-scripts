-- SQL to identify issues with large worklog history
-- https://jira.atlassian.com/browse/JRASERVER-45903

-- node reindex replication fails for single issues with 1000 or more worklog entries
-- https://jira.atlassian.com/browse/JRASERVER-71980


SELECT concat(p.pkey,'-',i.issuenum) as issue, count(a.id) as CountWorklogs
FROM worklog a, jiraissue i, project p
WHERE i.project = p.id
    AND i.id = a.issueid
GROUP BY p.pkey,i.issuenum
HAVING count(a.id) > 900
ORDER BY CountWorklogs DESC
limit 100;