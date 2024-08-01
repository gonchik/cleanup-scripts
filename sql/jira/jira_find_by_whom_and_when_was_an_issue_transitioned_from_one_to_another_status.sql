/*
    How to find by whom and when was an issue transitioned from one status to another in Jira using SQL queries
    Purpose:
    You may need to pull some information about who/when transitioned an issue from one status to another for reporting purposes.
    To retrieve this information from Jira UI, you can use the JQL "status changed FROM 'First' TO 'Second'" to filter tickets which were moved from 'First' to 'Second' status. Then go through the history of the tickets manually to see the user who performed the action.

    Since the operation above is time consuming, this article offers an alternative to get the data directly from the database using SQL queries.
    link: https://confluence.atlassian.com/jirakb/how-to-find-by-whom-and-when-was-an-issue-transitioned-from-one-status-to-another-in-jira-using-sql-queries-1283687816.html
 */

select i.field, i.oldstring, i.newstring, a.lower_user_name, g.created
from changeitem i
         join changegroup g on g.id = i.groupid
         join jiraissue j on j.id = g.issueid
         join project p on p.id = j.project
         join app_user a on a.user_key = g.author
where i.field = 'status'
  and i.oldstring = 'First' -- old status
  and i.newstring = 'Second' -- new status
  and j.issuenum = 123 -- issue number
  and p.pkey = 'ABC';
