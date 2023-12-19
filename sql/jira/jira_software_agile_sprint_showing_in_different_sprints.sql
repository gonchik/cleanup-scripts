/*
    Backlog doesn't show issues in the correct sprints
    link: https://jira.atlassian.com/browse/JSWSERVER-13530
 */
-- Backup all the "sprint-removal history items" into a separate table, and remove them from the initial table
create table changeitem_quarantine_jira721 as
select ci.*
from changeitem ci
where ci.field = 'Sprint'
  and ci.newvalue is null;

-- Remove them from the initial changeitem table
DELETE
from changeitem ci
where ci.id in (select id from changeitem_quarantine_jira721);


-- If any misbehaviour happens, the records can be restored again with the statement:
insert into changeitem
select *
from changeitem_quarantine_jira721
where id not in (select id from changeitem);