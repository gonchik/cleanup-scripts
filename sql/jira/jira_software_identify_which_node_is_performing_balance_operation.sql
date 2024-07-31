/*
    How to Identify Which Node is Performing Balance Operation
    This query will return the node_id and the time when the balance operation is performed.
    link: https://confluence.atlassian.com/jirakb/how-to-identify-which-node-is-performing-balance-operation-779158614.html
 */
select locked_by_node
from clusterlockstatus
where lock_name = 'com.atlassian.greenhopper.service.lexorank.balance.LexoRankBalancer';
