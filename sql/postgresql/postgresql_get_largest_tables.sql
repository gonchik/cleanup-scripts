/*
 * This query returns list of largest (by data size) tables.
 */
SELECT schemaname                                    as table_schema,
       relname                                       as table_name,
       pg_size_pretty(pg_total_relation_size(relid)) as total_size,
       pg_size_pretty(pg_relation_size(relid))       as data_size,
       pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid))
                                                     as external_size
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC ,
         pg_relation_size(relid) DESC
LIMIT 10;