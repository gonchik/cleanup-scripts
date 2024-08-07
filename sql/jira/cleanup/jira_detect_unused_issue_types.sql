/*
     How to find unused issue types with SQL
     Problem: A Jira administrator may want to identify any issue types
     which are not being used across the instance. In other words,
     no issues of these issue types exist and therefore may be considered unnecessary clutter.
     link: https://confluence.atlassian.com/jirakb/how-to-find-unused-issue-types-with-sql-1072216995.html
 */

-- This query will return the name and id of any issue type which is currently not in-use.
SELECT pname, id
FROM issuetype
WHERE id
    IN (SELECT optionid FROM optionconfiguration)
  AND id
    NOT IN (SELECT DISTINCT(issuetype) FROM jiraissue);


-- It is also possible to restrict this to specific issue type schemes.
-- For example, the query below only looks for issue types from the default issue type scheme.

SELECT pname, id
FROM issuetype
WHERE id
    IN (SELECT optionid FROM optionconfiguration WHERE fieldconfig = 10000)
  AND id
    NOT IN (SELECT DISTINCT(issuetype) FROM jiraissue);