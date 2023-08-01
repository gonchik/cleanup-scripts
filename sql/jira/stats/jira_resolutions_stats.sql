-- How many tickets linked to exact Resolutions in Jira

SELECT re.pname,
       (SELECT count(ji.id)
        FROM jiraissue ji
        WHERE re.id = ji.RESOLUTION) as "Number of linked tickets"
FROM resolution re
ORDER BY 2 ASC;