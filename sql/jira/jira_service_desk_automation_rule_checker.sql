/*
 * Loading Automation and/or Customer notifications in Jira Service Management throws Internal Server Error
 * https://confluence.atlassian.com/jirakb/loading-automation-and-or-customer-notifications-in-jira-service-management-throws-internal-server-error-777026946.html
 */

SELECT *
FROM "AO_9B2E3B_RULE"
WHERE "ID" is null or "ORDINAL" is null or "RULESET_REVISION_ID" is null or "ENABLED" is null;

SELECT * FROM "AO_9B2E3B_RULESET"
WHERE  "ACTIVE_REVISION_ID" is null or "ID" is null;

SELECT * FROM "AO_9B2E3B_RULESET_REVISION"
WHERE  "CREATED_BY" is null or "CREATED_TIMESTAMP_MILLIS" is null or "DESCRIPTION" is null or "ID" is null or "NAME" is null or "RULE_SET_ID" is null or "TRIGGER_FROM_OTHER_RULES" is null or "IS_SYSTEM_RULE_SET" is null;

SELECT * FROM "AO_9B2E3B_RULE_EXECUTION"
WHERE "EXECUTOR_USER_KEY" is null or "FINISH_TIME_MILLIS" is null or "ID" is null or "OUTCOME" is null or "RULE_ID" is null or "START_TIME_MILLIS" is null;