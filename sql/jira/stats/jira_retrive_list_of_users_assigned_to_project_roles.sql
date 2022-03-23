-- Retrieve a list of users assigned to project roles in Jira server
-- https://confluence.atlassian.com/jirakb/retrieve-a-list-of-users-assigned-to-project-roles-in-jira-server-705954232.html


SELECT p.pname, pr.NAME, u.display_name
FROM projectroleactor pra
         INNER JOIN projectrole pr ON pr.ID = pra.PROJECTROLEID
         INNER JOIN project p ON p.ID = pra.PID
         INNER JOIN app_user au ON au.user_key = pra.ROLETYPEPARAMETER
         INNER JOIN cwd_user u ON u.lower_user_name = au.lower_user_name;