/*
    link: https://jira.atlassian.com/browse/JIRAAUTOSERVER-266
 */

-- Count how many items we have waiting to be processed
SELECT count(*)
FROM "AO_589059_AUTOMATION_QUEUE";

-- Shows which rules have events waiting to processed
SELECT "RULE_ID", count(*)
FROM "AO_589059_AUTOMATION_QUEUE"
GROUP BY "RULE_ID"
order by count desc;

-- Shows how many rule ran per hour in last 2 weeks.
-- Including total & avg duration during that hour
SELECT date_trunc('hour', "CREATED") AS rule_ran_hour, count(*), sum("DURATION"), avg("DURATION")
FROM "AO_589059_AUDIT_ITEM"
WHERE "CREATED" > (now() - interval '2 week')
GROUP BY rule_ran_hour
ORDER BY rule_ran_hour;

-- shows top 50 rules ordered by how much time they were in the queue in total in the last 2 weeks
SELECT ai."OBJECT_ITEM_ID"            as rule_id,
       rc."NAME"                      as rule_name,
       count(*),
       avg("DURATION")                AS time_avg_ms,
       avg("END_TIME" - "START_TIME") AS queued_time_avg
FROM "AO_589059_AUDIT_ITEM" ai
         JOIN "AO_589059_RULE_CONFIG" rc ON "OBJECT_ITEM_ID" = rc."ID"
WHERE ai."CREATED" > (now() - INTERVAL '2 week')
GROUP BY "OBJECT_ITEM_ID", rc."NAME"
ORDER BY queued_time_avg DESC LIMIT 50;