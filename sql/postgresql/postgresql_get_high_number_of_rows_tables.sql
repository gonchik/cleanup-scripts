/*
 *
 * Get list of high number of rows tables, helps to the detecting where large tables
 *
 */

SELECT n.nspname as table_schema,
       c.relname as table_name,
       c.reltuples as rows
FROM pg_class c
    join pg_namespace n
on n.oid = c.relnamespace
WHERE c.relkind = 'r'
  and n.nspname not in ('information_schema'
    , 'pg_catalog')
order by c.reltuples desc
    limit 10;