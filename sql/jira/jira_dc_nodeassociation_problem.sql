/*
    500 CacheException error thrown during upgrade/restore of Jira server
    https://confluence.atlassian.com/jirakb/500-cacheexception-error-thrown-during-upgrade-restore-of-jira-server-800858895.html
*/



select * from nodeassociation where source_node_entity = 'Project' and source_node_id not in (select id from project);


-- delete from nodeassociation where source_node_entity = 'Project' and source_node_id not in (select id from project);
