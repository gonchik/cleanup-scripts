-- JiraDashboardStateStoreManager leave left-over rows in 'clusterlockstatus' table.
-- https://jira.atlassian.com/browse/JRASERVER-69113
-- Workflow scheme actions leave left-over rows in 'clusterlockstatus' table.
-- https://jira.atlassian.com/browse/JRASERVER-68477
select count(id)
from clusterlockstatus;

SELECT count(id)
FROM clusterlockstatus
WHERE update_time < (EXTRACT(EPOCH FROM (NOW() - INTERVAL '3 days')) * 1000);

/*
    DELETE that clusterlockstatus rows
 */
DELETE
FROM clusterlockstatus
WHERE update_time < (EXTRACT(EPOCH FROM (NOW() - INTERVAL '3 days')) * 1000);
