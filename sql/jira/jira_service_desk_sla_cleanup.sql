/*
    link: https://jira.atlassian.com/browse/JSDSERVER-5871
 */

SELECT *
FROM propertyentry
         JOIN propertynumber ON propertyentry.ID = propertynumber.ID
WHERE PROPERTY_KEY = 'sd.sla.audit.log.cleanup.days';

-- possible cleanup all data of SLA AUDIT LOG
truncate "AO_54307E_SLAAUDITLOG" cascade;
