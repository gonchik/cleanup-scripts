/*
    Jira server fails to start with Too many rows found for query on ClusteredJob error

 */


-- diagnosis
SELECT *
FROM clusteredjob
WHERE job_id in (SELECT job_id FROM clusteredjob GROUP BY job_id HAVING COUNT(*) > 1);

-- resolution
-- delete duplicated clustered job

