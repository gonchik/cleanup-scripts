/*
    How many tickets linked to exact status in Jira
 */

SELECT it.pname,
       (SELECT count(ji.id) from jiraissue ji where it.id = ji.issuestatus) as "Count of tickets"
FROM issuestatus it
ORDER BY 2 ASC;