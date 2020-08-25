-- Just detect problem with duplicate field on the screens
-- Duplicate key error in Jira server on creating issue via REST API or accessing Custom Fields page in JIRA
-- https://confluence.atlassian.com/jirakb/duplicate-key-error-in-jira-server-on-creating-issue-via-rest-api-or-accessing-custom-fields-page-in-jira-872016885.html
SELECT f.name, i.fieldidentifier, count(*)
FROM fieldscreen f, fieldscreenlayoutitem i, fieldscreentab t
WHERE f.id = t.fieldscreen
    AND i.fieldscreentab = t.id
GROUP BY f.name, i.fieldidentifier
HAVING count(*) > 1;
