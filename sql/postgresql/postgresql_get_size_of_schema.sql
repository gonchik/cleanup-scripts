/*
    Get size of schemas
 */

SELECT A.schemaname,
       pg_size_pretty(SUM(pg_relation_size(C.oid))) as table,
       pg_size_pretty (SUM(pg_total_relation_size(C.oid)-pg_relation_size(C.oid))) as index,
       pg_size_pretty (SUM(pg_total_relation_size(C.oid))) as table_index,
       SUM(n_live_tup)
FROM pg_class C
    LEFT JOIN pg_namespace N
ON (N.oid = C.relnamespace)
    INNER JOIN pg_stat_user_tables A ON C.relname = A.relname
WHERE nspname NOT IN ('pg_catalog'
    , 'information_schema')
  AND C.relkind <> 'i'
  AND nspname !~ '^pg_toast'
GROUP BY A.schemaname;