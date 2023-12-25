/*
    Cleanup JMWE (Jira Misc Workflow Extensions) execution log
 */


SELECT count(*)
FROM "AO_7AEB56_EXECUTION_LOG";


-- cleanup table
TRUNCATE TABLE "AO_7AEB56_EXECUTION_LOG";