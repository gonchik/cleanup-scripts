/*
    Find open connections
*/

SELECT COUNT(*) as connections,
       backend_type
FROM pg_stat_activity
where state = 'active' OR state = 'idle'
-- datname = <your_database>

GROUP BY backend_type
ORDER BY connections DESC;
