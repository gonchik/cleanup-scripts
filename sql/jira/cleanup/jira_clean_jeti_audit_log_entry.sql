/*
    Clean Jeti audit log entry
 */
DELETE
FROM "AO_544E33_AUDIT_LOG_ENTRY"
WHERE "SEND_TIME_STAMP" > current_date - interval '60' day;