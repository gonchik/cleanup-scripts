/*
    Stats of tickets per projects
*/
SELECT p.pkey, COUNT(i.id)
FROM jiraissue i
INNER JOIN project p ON i.project = p.id
GROUP BY (p.id)
ORDER BY count desc;