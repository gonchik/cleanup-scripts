/*
    Clean Jeti (Email this Issue) audit log entry
    i.e. longer than 2 month
 */

SELECT count("ID")
FROM "AO_544E33_AUDIT_LOG_ENTRY"
WHERE "SEND_TIME_STAMP" < current_date - interval '60' day;

DELETE
FROM "AO_544E33_AUDIT_LOG_ENTRY"
WHERE "SEND_TIME_STAMP" < current_date - interval '60' day;