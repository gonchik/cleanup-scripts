/*
 *
 * How to manually delete an Automation Rule on the database in Jira
 * https://confluence.atlassian.com/jirakb/how-to-manually-delete-an-automation-rule-on-the-database-in-jira-1050544443.html
 */

select rule."ID"                as "Rule ID",
       rule."NAME"              as "Rule name",
       rule."DESCRIPTION"       as "Rule Description",
       rule."STATE"             as "Rule status",
       rule."CREATED"           as "Rule creation date",
       rule."UPDATED"           as "Rule last updated date",
       state."CURRENT_CREATED"  as "Rule last execution status date",
       state."CURRENT_CATEGORY" as "Rule last execution status",
       state."EXEC_COUNT"       as "Rule execution count"
from "AO_589059_RULE_CONFIG" rule
         left join "AO_589059_RULE_STATE_LATEST" state on state."RULE_ID" = rule."ID";
