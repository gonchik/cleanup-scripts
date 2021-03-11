-- How to Get a List of Projects that has Anonymous Access in Jira from Database
-- https://confluence.atlassian.com/jirakb/how-to-get-a-list-of-projects-that-has-anonymous-access-in-jira-from-database-794368099.html

SELECT p.id, p.pname, ps.name FROM project p
INNER JOIN nodeassociation na ON
p.id = na.source_node_id
INNER JOIN schemepermissions sp ON
na.sink_node_id = sp.scheme
INNER JOIN permissionscheme ps ON
na.sink_node_id = ps.id
WHERE na.source_node_entity = 'Project'
AND na.sink_node_entity = 'PermissionScheme'
AND sp.permission_key='BROWSE_PROJECTS'
AND sp.perm_type='group'
AND sp.perm_parameter is null