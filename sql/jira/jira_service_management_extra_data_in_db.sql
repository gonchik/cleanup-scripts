/*
    Clean up extra Service Management data in the db
    link: https://confluence.atlassian.com/jirakb/clean-up-extra-service-management-data-in-the-db-777026997.html
 */
select date_trunc('month', cg.created),
       sum(coalesce(pg_column_size(ci.oldstring), 0))
           + sum(coalesce(pg_column_size(ci.newstring), 0))
           as total
from changegroup as cg,
     changeitem as ci
where ci.groupid = cg.id
  and ci.field in (select cfname
                   from customfield
                   where customfieldtypekey like 'com.atlassian.servicedesk%')
group by date_trunc('month', cg.created)
order by date_trunc('month', cg.created);


/*
    Resolution:
    Per JSDSERVER-1060 - SLA field write large JSON change items to the database CLOSED you need to upgrade to
    Jira Service Management 2.1+ to fix this issue.
    You can delete the bad data from the DB. We recommend performing a VACUUM / ANALYZE after the deletion completes.
 */

delete
from changegroup
where id in (select id
             from changegroup
             where id in (select groupid
                          from changeitem
                          where field in
                                (select cfname
                                 from customfield
                                 where customfieldtypekey like 'com.atlassian.servicedesk%'))
             except
             (select groupid
              from changeitem
              where field not in
                    (select cfname
                     from customfield
                     where customfieldtypekey like 'com.atlassian.servicedesk%')));

delete
from changeitem
where field in
      (select cfname
       from customfield
       where customfieldtypekey like 'com.atlassian.servicedesk%');
