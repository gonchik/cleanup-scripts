-- Jira Data Center Functionalities Loss Due to Cluster Wide Lock
-- https://confluence.atlassian.com/jirakb/jira-data-center-functionalities-loss-due-to-cluster-wide-lock-942860754.html
/*
    This only affects Jira Data Center - the application is not responding
    on any system administration page. Node restart causes
    the node to be stuck during application startup due to another node holding a cluster wide lock.
*/
select * from clusterlockstatus where locked_by_node is not null;
