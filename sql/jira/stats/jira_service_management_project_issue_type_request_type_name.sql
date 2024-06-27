/*
    Export Project - Issue Type - Customer Request Type

 */

SELECT p.pname  as project_name,
       p.pkey   as project_key,
       it.pname as issue_type_name,
       r."NAME" as request_type_name
FROM "AO_54307E_VIEWPORT" po,
     "AO_54307E_VIEWPORTFORM" r,
     project p,
     issuetype it
WHERE po."ID" = r."VIEWPORT_ID"
  AND po."PROJECT_ID" = p.id
  AND r."ISSUE_TYPE_ID" = CAST(it.id AS BIGINT)
ORDER BY p.pname;
