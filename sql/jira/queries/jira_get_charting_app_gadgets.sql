/*
    Detect charting plugin gadget to understand the usage
    https://jira.atlassian.com/browse/JRASERVER-67011
 */

SELECT count(*)
FROM portletconfiguration
WHERE gadget_xml LIKE '%com.atlassian.jira.ext.charting%';