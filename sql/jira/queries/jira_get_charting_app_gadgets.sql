-- https://jira.atlassian.com/browse/JRASERVER-67011
-- Detect charting plugin gadget to understand the usage
select count(*) from portletconfiguration
where gadget_xml LIKE '%com.atlassian.jira.ext.charting%'