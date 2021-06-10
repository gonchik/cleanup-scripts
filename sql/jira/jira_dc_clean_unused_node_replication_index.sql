-- let's remove  replicated info from unused node
delete FROM replicatedindexoperation rep WHERE rep.node_id NOT IN (SELECT node_id from clusternode);