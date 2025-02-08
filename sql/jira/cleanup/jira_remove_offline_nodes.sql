-- https://confluence.atlassian.com/jirakb/remove-abandoned-or-offline-nodes-in-jira-data-center-946616137.html
-- CHECK Offline node and remove it
-- https://jira.atlassian.com/browse/JRASERVER-42916


select NODE_ID from clusternode where NODE_STATE ='OFFLINE';


-- delete offline node
delete from clusternode where node_id IN (select NODE_ID from clusternode where NODE_STATE ='OFFLINE');
