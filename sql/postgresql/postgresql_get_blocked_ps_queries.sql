/*

    Finding blocked processes and blocking queries

*/
SELECT
    activity.pid,
    activity.usename,
    activity.query,
    blocking.pid AS blocking_id,
    blocking.query AS blocking_query
FROM pg_stat_activity AS activity
JOIN pg_stat_activity AS blocking ON blocking.pid = ANY(pg_blocking_pids(activity.pid));

/*
    Viewing locks with table names and queries
*/

select
    relname as relation_name,
    query,
    pg_locks.*
from pg_locks
join pg_class on pg_locks.relation = pg_class.oid
join pg_stat_activity on pg_locks.pid = pg_stat_activity.pid;