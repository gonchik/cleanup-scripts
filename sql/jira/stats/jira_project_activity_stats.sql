/*
    That request shows Jira project of last issue activity to understand the frequency
*/


SELECT DISTINCT p.pkey as "KEY",
				p.pname as "Project Name",
				MAX(i.UPDATED) as "Last Ticket Updated",
				pc.cname as "CATEGORY"
FROM jiraissue i
INNER JOIN project p ON p.ID = i.PROJECT
INNER JOIN nodeassociation na ON na.source_node_id=p.id
INNER JOIN projectcategory pc ON na.sink_node_id=pc.id
WHERE  na.sink_node_entity='ProjectCategory' and na.association_type='ProjectCategory'
GROUP BY i.PROJECT, p.pname
ORDER BY MAX(i.UPDATED) ASC, i.PROJECT, p.pname