-- let's remove  replicated info from unused node

SELECT count(*)
FROM replicatedindexoperation rep
WHERE rep.node_id NOT IN (SELECT node_id from clusternode);

-- delete FROM replicatedindexoperation rep WHERE rep.node_id NOT IN (SELECT node_id from clusternode);
