/*
    Get info from clustered job table
 */
select id,
       job_id,
       sched_type,
       interval_millis,
       cron_expression,
       cron_expression,
       time_zone,
       next_run
from clusteredjob;