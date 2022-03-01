/*
    Number of tickets grouped by month of creation
    Purpose: make an overview
*/

SELECT date_format(created, '%Y-%m') as "Year - Month",
       count(*)                      as "Total cases"
FROM jiraissue
GROUP BY year (created), month (created);


--  postgresql query
SELECT to_char(DATE_TRUNC('month', created),'YYYY-MM') as "Year - Month",
       count(*)                  as "Total cases"
FROM jiraissue
GROUP BY DATE_TRUNC('month', created), DATE_TRUNC('year', created);