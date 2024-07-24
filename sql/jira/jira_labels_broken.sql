/*
    Updating Labels in Jira using SQL
    link: https://confluence.atlassian.com/jirakb/updating-labels-in-jira-using-sql-1345820764.html
 */

SELECT *
FROM "label"
where "label" like '% %';

-- fix
UPDATE "label"
SET "label" = replace("label", ' ', '_')
where "label" like '% %';
