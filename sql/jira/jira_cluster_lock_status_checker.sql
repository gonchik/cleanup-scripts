/*
    Jira Data Center Functionalities Loss Due to Cluster Wide Lock
    This only affects Jira Data Center - the application is not responding
    on any system administration page. Node restart causes
    the node to be stuck during application startup due to another node holding a cluster wide lock.
    link: https://jira.atlassian.com/browse/JRASERVER-69114
    https://confluence.atlassian.com/jirakb/jira-data-center-functionalities-loss-due-to-cluster-wide-lock-942860754.html

*/


SELECT count(*)
FROM clusterlockstatus
WHERE locked_by_node is not null;

-- cleanup of unlocked_nodes
DELETE
FROM clusterlockstatus
WHERE locked_by_node is NULL;