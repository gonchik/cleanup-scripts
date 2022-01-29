/*

    Provide a connection stats for PostgreSQL clients
    Purpose: activity of clients
 */


with states as
    (select datname, client_addr, case
        when now() - state_change < interval '10 seconds' then '10sec'
        when now() - state_change < interval '30 seconds' then '30sec'
        when now() - state_change < interval '60 seconds' then '60sec'
        else 'idle' end
    as stat from pg_stat_activity)
select datname, client_addr, stat, count(*)
from states group by datname, client_addr, stat;