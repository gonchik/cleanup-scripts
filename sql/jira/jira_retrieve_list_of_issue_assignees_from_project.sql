/*
    Retrieve a list of issue assignees from a specific project in Jira
    Purpose: Admins may want to retrieve a list of issue assignees from a specific project in Jira.
    link: https://confluence.atlassian.com/jirakb/retrieve-a-list-of-issue-assignees-from-a-specific-project-in-jira-1102614385.html
 */
SELECT DISTINCT u.display_name, au.lower_user_name, j.assignee
FROM jiraissue j
         JOIN app_user au ON j.assignee = au.user_key
         JOIN cwd_user u ON u.lower_user_name = au.lower_user_name
WHERE j.project = 12345;