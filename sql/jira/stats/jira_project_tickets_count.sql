/*
    Stats number of tickets per every project in Jira
*/

SELECT p.pname     AS "Project Name",
       p.pkey      AS "Project Key",
       COUNT(i.id) AS "No. Issue"
FROM jiraissue i
         INNER JOIN project p ON i.project = p.id
GROUP BY (p.id)
ORDER BY count desc;