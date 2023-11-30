/*
    SQL to find unused SLA
    https://confluence.atlassian.com/jirakb/how-to-find-the-usage-of-sla-fields-in-jira-service-manager-1041828257.html
 */
SELECT DISTINCT cf.cfname
FROM customfield cf
WHERE cf.customfieldtypekey = 'com.atlassian.servicedesk:sd-sla-field'
  AND cf.id not in (SELECT cf2.id
                    FROM customfield cf2,
                         customfieldvalue cfv
                    WHERE cf2.customfieldtypekey = 'com.atlassian.servicedesk:sd-sla-field'
                      AND cfv.customfield = cf2.id
                      AND cfv.textvalue like '%"events":[{%');