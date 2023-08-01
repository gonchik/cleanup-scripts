-- CUSTOM FIELD VALUE CHANGES
-- issuenum
-- pkey
-- https://confluence.atlassian.com/jirakb/retrieve-issue-change-history-from-database-in-jira-server-933695139.html
SELECT p.pname,
       p.pkey,
       i.issuenum,
       cg.ID,
       cg.issueid,
       au.lower_user_name,
       cg.AUTHOR,
       cg.CREATED,
       ci.FIELDTYPE,
       ci.FIELD,
       ci.OLDVALUE,
       ci.OLDSTRING,
       ci.NEWVALUE,
       ci.NEWSTRING
FROM changegroup cg
         inner join jiraissue i on cg.issueid = i.id
         inner join project p on i.project = p.id
         inner join changeitem ci
                    on ci.groupid = cg.id AND ci.FIELDTYPE = 'custom' AND ci.FIELD = 'Name of Custom Field'
         inner join app_user au on cg.author = au.user_key
WHERE cg.issueid = (select id
                    from jiraissue
                    where issuenum = 115 and project in (select id from project where pname = 'Project name'))
order by 1, 3, 4;