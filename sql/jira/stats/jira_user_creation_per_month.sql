/*
    User creation per month.
    Note: it can be users without access to Jira app
*/

SELECT date_format(created_date, '%Y-%m'), count(*)
FROM cwd_user
GROUP BY year(created_date), month(created_date);