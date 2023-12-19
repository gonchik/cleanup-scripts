/*
    Find the last login date for a user in Jira server
    link: https://confluence.atlassian.com/jirakb/find-the-last-login-date-for-a-user-in-jira-server-363364638.html
    Purpose:
    Get a list of users showing their last login timestamp
    from the database in order to audit application usage.
    Please keep in mind that if the user has a "Remember Me" token set,
    then the Last Login date will not reflect the last time the user accessed JIRA,
    but will instead show the last time they had to go through the login process.
    See: JRA-60508 for details.
 */


SELECT d.directory_name                                     AS "Directory",
       u.user_name                                          AS "Username",
       u.active                                             AS "Active",
       to_timestamp(CAST(attribute_value AS BIGINT) / 1000) AS "Last Login"
FROM cwd_user u
         JOIN (SELECT DISTINCT child_name
               FROM cwd_membership m
                        JOIN licenserolesgroup gp ON m.lower_parent_name = gp.GROUP_ID) AS m
              ON m.child_name = u.user_name
         LEFT JOIN (SELECT *
                    FROM cwd_user_attributes ca
                    WHERE attribute_name = 'login.lastLoginMillis') AS a ON a.user_id = u.ID
         JOIN cwd_directory d ON u.directory_id = d.id
ORDER BY "Last Login" DESC;