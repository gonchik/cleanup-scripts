-- How to identify group usage in JIRA
-- https://confluence.atlassian.com/jirakb/how-to-identify-group-usage-in-jira-441221524.html

/*
 * All queries below were composed for PostgreSQL databases
   and may need slight syntax adjustments depending on the DBMS JIRA's database is based on.

   Replace ('helpdesk', 'administrators') with a comma-separated list
   of the groups you want to check for usages.
*/

-- Project Roles ---
SELECT
  pra.roletypeparameter AS "Group",
  pr.name AS "Project Role",
  p.pname AS "Project"
FROM
  projectroleactor pra
  LEFT JOIN projectrole pr ON pra.projectroleid = pr.id
  LEFT JOIN project p ON pra.pid = p.id
WHERE
  pra.roletype = 'atlassian-group-role-actor'
  AND pra.roletypeparameter in ('helpdesk', 'administrators');



-- Global Permissions ---
SELECT
  gp.group_id AS "Group",
  gp.permission AS "Permission"
FROM
  globalpermissionentry gp
WHERE
  gp.group_id in ('helpdesk', 'administrators');



-- Custom Fields ---
SELECT
  cfv.stringvalue AS "Group(s)",
  cf.cfname AS "Custom Field",
  CONCAT(p.pkey, '-', ji.issuenum) AS "Issue"
FROM
  customfieldvalue cfv
  LEFT JOIN customfield cf ON cf.id = cfv.customfield
  LEFT JOIN jiraissue ji ON cfv.issue = ji.id
  LEFT JOIN project p ON ji.project = p.id
WHERE
  cf.customfieldtypekey IN (
    'com.atlassian.jira.plugin.system.customfieldtypes:grouppicker',
    'com.atlassian.jira.plugin.system.customfieldtypes:multigrouppicker'
  )
  AND cfv.stringvalue in ('helpdesk','administrators');



-- Shared Dashboards ---
SELECT
  shp.param1 AS "Group",
  pp.pagename AS "Dashboard"
FROM
  sharepermissions shp
  LEFT JOIN portalpage pp ON shp.entityid = pp.id
WHERE
  shp.entitytype = 'PortalPage'
  AND shp.sharetype = 'group'
  AND shp.param1 IN ('helpdesk', 'administrators');



-- Shared Filters ---
SELECT
  shp.param1 AS "Group",
  sr.filtername AS "Filter"
FROM
  sharepermissions shp
  LEFT JOIN searchrequest sr ON shp.entityid = sr.id
WHERE
  shp.entitytype = 'SearchRequest'
  AND shp.sharetype = 'group'
  AND shp.param1 IN ('helpdesk', 'administrators');



-- Workflows ---
SELECT
  jw.workflowname AS "Workflow",
  jw.descriptor AS "Descriptor"
FROM
  jiraworkflows jw;



-- Filter Subscriptions ---
SELECT
  fs.groupname AS "Group"
FROM
  filtersubscription fs
  LEFT JOIN searchrequest sr ON fs.filter_i_d = sr.id
WHERE
  fs.groupname IN ('helpdesk','administrators');



-- Board Administrators (JIRA Agile) ---
SELECT
  ba."KEY" AS "Group",
  rv."NAME" AS "Board"
FROM
  "AO_60DB71_BOARDADMINS" ba
  LEFT JOIN "AO_60DB71_RAPIDVIEW" rv ON ba."RAPID_VIEW_ID" = rv."ID"
WHERE
  ba."TYPE" = 'GROUP'
  AND ba."KEY" IN ('helpdesk','administrators');



-- Application Access (JIRA 7+) ---
SELECT
	license_role_name AS "Application",
	group_id AS "Group"
FROM
	licenserolesgroup
WHERE
	group_id in ('helpdesk','administrators');



-- Saved Filters content
SELECT
	id AS "Filter ID",
	filtername AS "Filter Name",
	reqcontent AS "JQL"
FROM
	searchrequest
WHERE
	LOWER(reqcontent) like '%helpdesk%';



-- Notification Schemes ---
SELECT
  *
FROM
  notification
WHERE
  notif_type LIKE '%Group%';



-- Permission Schemes ---
SELECT
  SP.id,SP.perm_parameter AS GroupName
FROM
  schemepermissions SP
INNER JOIN
  permissionscheme PS ON SP.scheme = PS.id
WHERE
  SP.perm_type = 'group'
  AND SP.perm_parameter in ('groupname');



-- Scheme Permissions Granted to Group ---
SELECT
  SP.perm_parameter AS GroupName, PS.name AS PermissionSchemeName, SP.permission_key AS Permission
FROM
  schemepermissions SP
INNER JOIN
  permissionscheme PS ON SP.scheme = PS.id
WHERE
  SP.perm_type = 'group'
  AND SP.perm_parameter in ('groupname');
