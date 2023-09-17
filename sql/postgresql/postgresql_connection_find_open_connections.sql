/*
    Find open connections
*/

SELECT  EXTRACT(EPOCH FROM (now() - backend_start)) AS backend_seconds, EXTRACT(EPOCH FROM (now() - query_start)) AS query_seconds, usename, client_addr, left(query,300)
       backend_type
FROM pg_stat_activity
where state = 'active' OR state = 'idle'
ORDER BY 1 ASC

-- datname = <your_database>

GROUP BY backend_type
ORDER BY connections DESC;



/*

    Kill idle open connections - that have been open > threshold (hours)

 */


\set idleThresholdMinutes 1

SELECT
    pg_terminate_backend(pid)
FROM
    pg_stat_activity
WHERE
  state = 'idle'
  AND EXTRACT(EPOCH FROM (now() - query_start)) / 60 > :idleThresholdMinutes
;