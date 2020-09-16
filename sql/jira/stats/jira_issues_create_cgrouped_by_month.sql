/*
    Number of tickets grouped by month of creation
*/

SELECT
		date_format(created, '%Y-%m') as "Year - Month",
		count(*) as "Total cases"
FROM jiraissue
GROUP BY year(created), month(created);