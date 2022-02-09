/*
    find tickets with large number of attachments
    purpose: detect broken automations
    link:  https://jira.atlassian.com/browse/JRASERVER-66251
 */

SELECT concat(p.pkey,'-',i.issuenum) as issue, count(f.id)
FROM fileattachment f, jiraissue i, project p
WHERE i.project = p.id and i.id = f.issueid
GROUP BY p.pkey,i.issuenum
HAVING count(i.id) > 100
ORDER BY count (i.id) desc
    LIMIT 100;