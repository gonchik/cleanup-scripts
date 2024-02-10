/*

    Compare rollbacks and commits
    Purpose: Compare commits and rollbacks for the understanding client activity

 */
SELECT sum(xact_commit)   as commits,
       sum(xact_rollback) as rollbacks
FROM pg_stat_database;