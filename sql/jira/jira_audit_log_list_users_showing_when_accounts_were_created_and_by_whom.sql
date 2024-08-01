/*
    List of users showing when the accounts were created and by whom
    link: https://confluence.atlassian.com/jirakb/list-of-users-showing-when-the-accounts-were-created-and-by-whom-695241575.html
 */
select author_key, object_id, created
from audit_log
where summary = 'User created'
  AND object_parent_name = 'JIRA Internal Directory'
ORDER BY created;
