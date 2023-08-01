/*
    SQL to find unused SLA
    https://confluence.atlassian.com/jirakb/how-to-find-the-usage-of-sla-fields-in-jira-service-manager-1041828257.html
 */
select distinct cf.cfname
from customfield cf
where cf.customfieldtypekey = 'com.atlassian.servicedesk:sd-sla-field'
  and cf.id not in (select cf2.id
                    from customfield cf2,
                         customfieldvalue cfv
                    where cf2.customfieldtypekey = 'com.atlassian.servicedesk:sd-sla-field'
                      and cfv.customfield = cf2.id
                      and cfv.textvalue like '%"events":[{%');