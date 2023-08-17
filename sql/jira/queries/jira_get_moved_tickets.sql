/*
    Get moved tickets based  on the change log
    How to list issues moved from one project to another in Jira

*/

select k.oldstring                     as "Old Key",
       coalesce(t.oldstring, it.pname) as "Old Type",
       k.newstring                     as "New Key",
       coalesce(t.newstring, it.pname) as "New Type",
       u.lower_user_name               as "Username",
       kg.created                      as "Moved date"
from changeitem k
         join changegroup kg on kg.id = k.groupid
         join app_user a on a.user_key = kg.author
         join cwd_user u on u.lower_user_name = a.lower_user_name
         join changegroup gt on gt.id = k.groupid
         left join changeitem t on t.groupid = gt.id and t.field = 'issuetype'
         join jiraissue i on i.id = kg.issueid
         join issuetype it on it.id = i.issuetype
where k.field = 'Key';

-- also, you can check in moved_issue_key table
