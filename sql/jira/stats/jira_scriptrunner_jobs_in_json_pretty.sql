/*
    Get job configs of Scriptrunner
 */
SELECT jsonb_pretty(t."SETTING"::jsonb)
FROM "AO_4B00E6_STASH_SETTINGS" t
WHERE t."KEY" = 'scheduled_jobs';