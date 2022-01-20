/*
 *
 * Compare rollbacks and commits
 *
 */
select sum(xact_commit) as commits,
       sum(xact_rollback) as rollbacks
from pg_stat_database;