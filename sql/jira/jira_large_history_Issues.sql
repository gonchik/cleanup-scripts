-- find top 100 with large history issues
-- https://jira.atlassian.com/browse/JRASERVER-66251

SELECT concat(p.pkey,'-',ji.issuenum) AS issue, count(ji.id)
FROM changeitem ci
         JOIN changegroup cg ON cg.id = ci.groupid
         JOIN jiraissue ji ON cg.issueid = ji.id
         JOIN project p ON p.id = ji.project
GROUP BY ji.issuenum,p.pkey
ORDER BY count(ji.id) DESC
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