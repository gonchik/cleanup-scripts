/*
    Check vacuum running status
 */

SELECT relname,
       last_vacuum,
       last_autovacuum
FROM pg_stat_user_tables;