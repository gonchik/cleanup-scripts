/*
    How to identify which Groups have access to a Project in JIRA
    https://confluence.atlassian.com/jirakb/how-to-identify-which-groups-have-access-to-a-project-in-jira-884354938.html

 */

SELECT project.pkey               as pkey,
       project.pname              as project_name,
       projectrole.name           as project_role_name,
       cwd_membership.parent_name as groupuser
FROM cwd_membership,
     projectrole,
     projectroleactor,
     project
WHERE project.id = projectroleactor.pid
  and projectroleactor.projectroleid = projectrole.id
  and roletype = 'atlassian-group-role-actor'
  and membership_type = 'GROUP_USER'
  and parent_name = roletypeparameter
GROUP BY pkey, project_name, project_role_name, groupuser;