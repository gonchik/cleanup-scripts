/*
    Identify users in Jira who haven't logged in for the past 90 days
    link: https://confluence.atlassian.com/jirakb/identify-users-in-jira-who-haven-t-logged-in-for-the-past-90-days-695241569.html
*/

SELECT d.directory_name                                        AS "Directory",
       u.user_name                                             AS "Username",
       to_timestamp(CAST(ca.attribute_value AS BIGINT) / 1000) AS "Last Login"
FROM cwd_user u
         JOIN cwd_directory d ON u.directory_id = d.id
         LEFT JOIN cwd_user_attributes ca ON u.id = ca.user_id AND ca.attribute_name = 'login.lastLoginMillis'
WHERE u.active = 1
  AND d.active = 1
  AND u.lower_user_name IN (SELECT DISTINCT lower_child_name
                            FROM cwd_membership m
                                     JOIN licenserolesgroup gp ON m.lower_parent_name = lower(gp.GROUP_ID))
  AND (u.id IN (SELECT ca.user_id
                FROM cwd_user_attributes ca
                WHERE attribute_name = 'login.lastLoginMillis'
                  AND to_timestamp(CAST(ca.attribute_value as bigint) / 1000) <= current_date - 90)
    OR u.id NOT IN (SELECT ca.user_id
                    FROM cwd_user_attributes ca
                    WHERE attribute_name = 'login.lastLoginMillis')
    )
ORDER BY "Last Login" DESC;