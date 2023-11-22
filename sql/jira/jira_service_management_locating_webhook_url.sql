/*
    Locating WebHook URL in Service Management automation rules
    link: https://confluence.atlassian.com/jirakb/locating-webhook-url-in-service-management-automation-rules-1056677121.html
 */


select thenactioncfgdata."ID",
       rsetrevision."CREATED_BY"             as "Rule created by",
       rsetrevision."DESCRIPTION"            as "Rule description",
       thenactioncfgdata."CONFIG_DATA_VALUE" as "Webhook URL"
from "AO_9B2E3B_RULE" r
         join "AO_9B2E3B_RULESET" rset on r."ID" = rset."ID"
         join "AO_9B2E3B_RULESET_REVISION" rsetrevision on rsetrevision."ID" = rset."ACTIVE_REVISION_ID"
         join "AO_9B2E3B_IF_THEN" ifthen on rset."ACTIVE_REVISION_ID" = ifthen."RULE_ID"
         join "AO_9B2E3B_THEN_ACTION_CONFIG" thenactioncfg on thenactioncfg."IF_THEN_ID" = ifthen."ID"
         join "AO_9B2E3B_THEN_ACT_CONF_DATA" thenactioncfgdata
              on thenactioncfg."ID" = thenactioncfgdata."THEN_ACTION_CONFIG_ID"
                  and thenactioncfgdata."CONFIG_DATA_KEY" ilike '%url%';