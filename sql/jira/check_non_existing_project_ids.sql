-- https://confluence.atlassian.com/jirakb/500-cacheexception-error-thrown-during-upgrade-restore-of-jira-server-800858895.html
-- https://jira.atlassian.com/browse/JRASERVER-70651
-- Double check cache exception


SELECT *
FROM nodeassociation
WHERE source_node_entity = 'Project'
       and source_node_id not in (select id from project);

-- fix
-- delete from nodeassociation where source_node_entity = 'Project' and source_node_id not in (select id from project);
