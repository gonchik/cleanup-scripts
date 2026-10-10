SELECT cfv.id, cfv.issue, cfv.updated, cfv.textvalue
FROM customfieldvalue cfv
         JOIN customfield cf ON cfv.customfield = cf.id
WHERE cf.customfieldtypekey = 'com.atlassian.servicedesk:sd-sla-field';



SELECT cfv.customfield,
       cfv.issue,
       COUNT(*) AS record_count
FROM customfieldvalue cfv
         JOIN customfield cf ON cfv.customfield = cf.id
WHERE cf.customfieldtypekey = 'com.atlassian.servicedesk:sd-sla-field'
  and cf.id = 10605
GROUP BY cfv.customfield, cfv.issue
HAVING COUNT(*) > 10;