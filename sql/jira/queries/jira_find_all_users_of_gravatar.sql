/*
    How to find all users, that make use of Gravatar for their profile in Jira

    As such Jira doesn't save the URL to the gravatar or saves this anywhere in the database.
    Instead Jira tries to collect the gravatar (if enabled)
    for every user that has the default profile picture.
    Also this will not work for users, that never changed their avatar, as this would be set as default.
 */


SELECT u.lower_user_name, a.*
FROM app_user AS u
         LEFT JOIN propertyentry AS pe ON pe.entity_id = u.id
         LEFT JOIN propertynumber AS pn ON pe.id = pn.id
         LEFT JOIN avatar AS a ON a.id = pn.propertyvalue
WHERE entity_name = 'ApplicationUser'
  AND property_key = 'user.avatar.id'
  AND a.filename = 'Avatar-default.svg';