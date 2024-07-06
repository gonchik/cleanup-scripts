/*
    JIRA Project Activity Level Stats per Project Updated last 30 days
*/

-- MySQL
SELECT DISTINCT p.pkey                as "KEY",
                p.pname               as "Project Name",
                COUNT(jiraissue.pkey) AS "Issue Updated Last 30 Days",
                pc.cname              as "CATEGORY"
FROM jiraissue i
         RIGHT OUTER JOIN project
                          ON jiraissue.project = project.ID AND jiraissue.updated > NOW() - 30
         INNER JOIN project p ON p.ID = i.PROJECT
         INNER JOIN nodeassociation na ON na.source_node_id = p.id
         INNER JOIN projectcategory pc ON na.sink_node_id = pc.id
WHERE na.sink_node_entity = 'ProjectCategory'
  and na.association_type = 'ProjectCategory'
GROUP BY p.pname, p.pkey, pc.cname
ORDER BY "Issue Updated Last 30 Days";


-- PostgreSQL
SELECT project.pname         AS "Project Name",
       COUNT(jiraissue.pkey) AS "Issue Updated Last 30 Days"
FROM jiraissue
         RIGHT OUTER JOIN project
                          ON jiraissue.project = project.ID
                              AND jiraissue.updated > NOW() - INTERVAL '30 DAY'
GROUP BY project.pname
ORDER BY "Issue Updated Last 30 Days";