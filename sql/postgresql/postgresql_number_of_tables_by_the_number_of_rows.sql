-- Get overview of high number of rows tables

select row_count,
       count(*) as tables
from (
select c.relname as table_name,
       n.nspname as table_schema,
       case
            when c.reltuples > 3000000000 then '3b rows and more'
            when c.reltuples > 1000000000 then '1b - 3b rows'
            when c.reltuples > 1000000 then '1m - 1b rows'
            when c.reltuples > 1000 then '1k - 1m rows'
            when c.reltuples > 100 then '100 - 1k rows'
            when c.reltuples > 10 then '10 - 100 rows'
            else  '0 - 10 rows' end as row_count,
      c.reltuples as rows
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where c.relkind = 'r'
       and n.nspname not in ('pg_catalog', 'information_schema')
) itv
group by row_count
order by max(rows);