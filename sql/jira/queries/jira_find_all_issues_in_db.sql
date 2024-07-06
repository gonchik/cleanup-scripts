/*
    Find all Jira issue in Database
    Export Jira tickets from Jira database to CSV
 */

SELECT CONCAT(p.pkey, '-', ji.issuenum) AS "issuekey",
       ji.summary,
       ji.description,
       ji.assignee,
       ji.creator,
       ji.created,
       ji.updated
FROM jiraissue ji
         JOIN project p ON ji.project = p.id
limit 1000;