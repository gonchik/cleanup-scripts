/*
    How many tickets linked to exact issue types in Jira
    Purpose: Make analysis of link type overall
 */

SELECT it.pname     AS "Issue Type",
       COUNT(ji.id) AS "Number Of Tickets"
FROM jiraissue ji
         INNER JOIN issuetype it ON ji.issuetype = it.id
-- WHERE ji.created BETWEEN '2023-01-01' AND '2023-06-01'
GROUP BY it.id
ORDER BY 2 DESC;