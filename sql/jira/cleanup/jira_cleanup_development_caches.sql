-- DETECT HOW MANY VALUES DO YOU HAVE IN Development panel
-- FYI: that info is like SQL cache

-- MySQL dialect
/*
    SELECT count(ID) FROM AO_575BF5_PROVIDER_ISSUE;
    TRUNCATE AO_575BF5_PROVIDER_ISSUE;
*/

-- PostgreSQL dialect
SELECT count("ID") FROM "AO_575BF5_PROVIDER_ISSUE";

TRUNCATE TABLE "AO_575BF5_PROVIDER_ISSUE";



-- DETECT AND CLEAN DEV SUMMARY INFO
-- mysql dialect
/*
    SELECT count(ID) FROM AO_575BF5_DEV_SUMMARY;
    TRUNCATE AO_575BF5_DEV_SUMMARY;
 */



-- PostgreSQL dialect
-- calculate count
SELECT count("ID") FROM "AO_575BF5_DEV_SUMMARY";

-- Execution
TRUNCATE TABLE "AO_575BF5_DEV_SUMMARY";