/*
    How many issue types there are per project in Jira
    Purpose: Admins may want to pull statistics of how many issue types there are per project in Jira.
    link: https://confluence.atlassian.com/jirakb/how-to-query-the-jira-database-for-issue-type-statistics-per-project-993922099.html
*/


SELECT p.pkey, it.pname, COUNT(i.id)
FROM jiraissue i
INNER JOIN project p ON i.project = p.id
INNER JOIN issuetype it ON it.id = i.issuetype
GROUP BY p.id, it.id
ORDER BY p.pkey, count(i.id) DESC;
