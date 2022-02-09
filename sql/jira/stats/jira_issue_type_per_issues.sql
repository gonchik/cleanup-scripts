/*
    How many tickets linked to exact issue types in Jira
    Purpose: Make analysis of link type overall
 */

SELECT it.pname,
		(SELECT count(ji.id) from jiraissue ji where it.id = ji.issuetype) as "Number of tickets"
FROM issuetype it
ORDER BY 2 ASC;