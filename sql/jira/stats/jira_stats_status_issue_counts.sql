/*
    How many tickets linked to exact status in Jira
 */

SELECT it.pname as "Status Name",
       (SELECT count(ji.id)
        FROM jiraissue ji
        WHERE it.id = ji.issuestatus) as "Count of tickets"
FROM issuestatus it
ORDER BY 2 ASC;