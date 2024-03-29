/*
    Jira Service Management queue cleanup
 */

DELETE
FROM "AO_319474_QUEUE_PROPERTY"
WHERE "QUEUE_ID" in (SELECT "ID"
                     FROM "AO_319474_QUEUE"
                     WHERE "CREATED_TIME" < (EXTRACT(EPOCH FROM (NOW() - INTERVAL '3 days')) * 1000));

DELETE
FROM "AO_319474_QUEUE"
WHERE "CREATED_TIME" < (EXTRACT(EPOCH FROM (NOW() - INTERVAL '3 days')) * 1000);


