/*
        Get monthly created request types
 */

SELECT to_char(DATE_TRUNC('month', created),'YYYY-MM') as "Monthly",
       p.pkey,
       (select r."NAME"
        FROM "AO_54307E_VIEWPORT" po, "AO_54307E_VIEWPORTFORM" r, project p
        WHERE po."ID"=r."VIEWPORT_ID" AND po."PROJECT_ID"=p.id and (po."KEY" || '/' || r."KEY") = c.stringvalue) as "Request Type",
       count(*)    as "Total cases"
FROM jiraissue ji
         INNER JOIN project p ON ji.project = p.id
         INNER JOIN customfieldvalue c on ji.id = c.issue and c.customfield=(SELECT id FROM customfield WHERE cfname='Customer Request Type')
GROUP BY DATE_TRUNC('month', created), p.pkey, "Request Type"
order by 2;