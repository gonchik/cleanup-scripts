/*
    Who never logged into Jira
    link: https://confluence.atlassian.com/jirakb/identify-users-in-jira-who-haven-t-logged-in-for-the-past-90-days-695241569.html
*/

select user_name from cwd_user where user_name not in
(SELECT cwd_user.user_name
FROM cwd_user, cwd_user_attributes
WHERE cwd_user_attributes.user_id = cwd_user.id
AND cwd_user_attributes.attribute_name = 'lastAuthenticated');