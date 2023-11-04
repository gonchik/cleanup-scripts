/*
    Get table sizes provided with detail info and simple info

 */
-- extended query
SELECT
       schemaname,
       C.relname AS "relation",
       pg_size_pretty (pg_relation_size(C.oid)) as table,
       pg_size_pretty (pg_total_relation_size (C.oid)-pg_relation_size(C.oid)) as index,
       pg_size_pretty (pg_total_relation_size (C.oid)) as table_index,
       n_live_tup
FROM pg_class C
    LEFT JOIN pg_namespace N ON (N.oid = C .relnamespace)
    LEFT JOIN pg_stat_user_tables A ON C.relname = A.relname
WHERE nspname NOT IN ('pg_catalog', 'information_schema')
  AND C.relkind <> 'i'
  AND nspname !~ '^pg_toast'
ORDER BY pg_total_relation_size (C.oid) DESC;

-- simple query
SELECT
    table_name,
    pg_size_pretty(pg_relation_size(quote_ident(table_name))),
    pg_relation_size(quote_ident(table_name))
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY  3 DESC ;