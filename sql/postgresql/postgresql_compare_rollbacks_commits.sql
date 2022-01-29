/*

    Compare rollbacks and commits
    Purpose: Compare commits and rollbacks for the understanding client activity

 */
select sum(xact_commit) as commits,
       sum(xact_rollback) as rollbacks
from pg_stat_database;