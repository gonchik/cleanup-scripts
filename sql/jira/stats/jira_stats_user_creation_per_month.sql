/*
    User creation per month.
    Note: it can be users without access to Jira app
*/

SELECT to_char(created_date, 'YYYY-MM') AS "Year",
       COUNT(*)                    AS "Number of Users"
FROM cwd_user
GROUP BY to_char(created_date, 'YYYY-MM')
ORDER BY 1 LIMIT 100;

SELECT to_char(created_date, 'YYYY') AS "Year",
       COUNT(*)                 AS "Number of Users"
FROM cwd_user
GROUP BY to_char(created_date, 'YYYY')
ORDER BY 1 LIMIT 100;


-- mysql query per month
SELECT date_format(created_date, '%Y-%m'), count(*)
FROM cwd_user
GROUP BY year (created_date), month (created_date)
ORDER BY 1;

SELECT date_format(created_date, '%Y'), count(*)
FROM cwd_user
GROUP BY year (created_date)
ORDER BY 1;