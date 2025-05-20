/*
    How to rename a group in Jira
    link: https://confluence.atlassian.com/jirakb/how-to-rename-a-group-in-jira-968662365.html
 */

-- Rename the group
update
    cwd_group
set group_name       = '<NEW_GROUP_NAME>'
  , lower_group_name = '<NEW_GROUP_NAME_LOWERCASE>'
where group_name = '<OLD_GROUP_NAME>'
  and group_type = 'GROUP';

-- Update the group name in all entities that are using it

-- 2.1. UPDATE USER MEMBERSHIP
update
    cwd_membership
set parent_name       = '<NEW_GROUP_NAME>'
  , lower_parent_name = '<NEW_GROUP_NAME_LOWERCASE>'
where parent_name = '<OLD_GROUP_NAME>'
  and membership_type = 'GROUP_USER';

-- 2.2. UPDATE GROUP MEMBERSHIP (NESTED GROUPS)
update
    cwd_membership
set child_name       = '<NEW_GROUP_NAME>'
  , lower_child_name = '<NEW_GROUP_NAME_LOWERCASE>'
  , child_id         = '<NEW_GROUP_ID>'
where child_name = '<OLD_GROUP_NAME>'
  and membership_type = 'GROUP_GROUP';
-- 2.3. UPDATE NOTIFICATION SCHEMES
update
    notification
set notif_parameter = '<NEW_GROUP_NAME>'
where notif_parameter = '<OLD_GROUP_NAME>'
  and notif_type = 'Group_Dropdown';
-- 2.4. UPDATE ISSUE SECURITY SCHEMES
update
    schemeissuesecurities
set sec_parameter = '<NEW_GROUP_NAME>'
where sec_parameter = '<OLD_GROUP_NAME>'
  and sec_type = 'group';
-- 2.5. UPDATE PERMISSION SCHEMES
update
    schemepermissions
set perm_parameter = '<NEW_GROUP_NAME>'
where perm_parameter = '<OLD_GROUP_NAME>'
  and perm_type = 'group';
-- 2.6. UPDATE SHARED EDIT RIGHTS
update
    sharepermissions
set param1 = '<NEW_GROUP_NAME>'
where param1 = '<OLD_GROUP_NAME>'
  and sharetype = 'group';


-- Note: Updating shared edit rights is required only for Jira 7.12, or later.
-- Earlier versions don't allow to share edit rights for filters and dashboards.

-- 2.7. UPDATE FILTER SUBSCRIPTIONS
update
    filtersubscription
set groupname = '<NEW_GROUP_NAME>'
where groupname = '<OLD_GROUP_NAME>';
-- 2.8. UPDATE COMMENT RESTRICTIONS
update
    jiraaction
set actionlevel = '<NEW_GROUP_NAME>'
where actionlevel = '<OLD_GROUP_NAME>';
-- 2.9. UPDATE WORK LOGS
update
    worklog
set grouplevel = '<NEW_GROUP_NAME>'
where grouplevel = '<OLD_GROUP_NAME>';
-- 2.10. UPDATE FILTERS
update
    searchrequest
set groupname = '<NEW_GROUP_NAME>'
where groupname = '<OLD_GROUP_NAME>';
-- 2.11. UPDATE PROJECT ROLES
update
    projectroleactor
set roletypeparameter = '<NEW_GROUP_NAME>'
where roletypeparameter = '<OLD_GROUP_NAME>'
  and roletype = 'atlassian-group-role-actor';
-- 2.12. UPDATE GLOBAL PERMISSIONS
update
    globalpermissionentry
set group_id = '<NEW_GROUP_NAME>'
where group_id = '<OLD_GROUP_NAME>';
-- 2.13. UPDATE LICENSE ROLE GROUPS
update
    licenserolesgroup
set group_id = '<NEW_GROUP_NAME_LOWERCASE>'
where group_id = '<OLD_GROUP_NAME_LOWERCASE>';
-- 2.14. UPDATE CUSTOM FIELD VALUES
update
    customfieldvalue
set stringvalue = '<NEW_GROUP_NAME>'
where stringvalue = '<OLD_GROUP_NAME>'
  and customfield in
      (select id
       from customfield
       where customfieldtypekey in (
                                    'com.atlassian.jira.plugin.system.customfieldtypes:multigrouppicker',
                                    'com.atlassian.jira.plugin.system.customfieldtypes:grouppicker'
           ));

/*
3. Find filters and workflows that contain group names
Group names can also be used in filters and workflows, but just changing them with SQL statements would be too risky and could result in errors. You can run the following queries to get a list of filters and workflows that contain your group names, and then edit them in Jira.

FIND FILTERS
select filtername
     , reqcontent
from searchrequest
where reqcontent like '%<OLD_GROUP_NAME>%';
After
you get a list of filters, go to Issues > Manage filters. Group names will usually be listed in the filter
’s JQL query.

FIND WORKFLOWS
*/
select workflowname
from jiraworkflows
where
    descriptor like '%<OLD_GROUP_NAME>%';