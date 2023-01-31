/*
    Find queries running longer than 5 minutes


    Kill long-running PostgreSQL query processes
    Where some queries look like they’re not going to finish, you can use the pid (process ID)
    from the pg_stat_activity or pg_locks views to terminate the running process.

    pg_cancel_backend(pid) will attempt to gracefully kill a running query process.
    pg_terminate_backend(pid) will immediately kill the running query process,
    but potentially have side affects across additional queries running on your database server.
    The full connection may be reset when running pg_terminate_backend, so other running queries can be affected.
    Use as a last resort.
*/
SELECT
  pid,
  user,
  pg_stat_activity.query_start,
  now() - pg_stat_activity.query_start AS query_time,
  query,
  state,
  wait_event_type,
  wait_event
FROM pg_stat_activity
WHERE (now() - pg_stat_activity.query_start) > interval '5 minutes';

