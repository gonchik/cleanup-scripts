/*
 *
    Get stats of your DB indexes.
    Interesting to understand which indexes is not used on your instance.
    After you can easier review tables via \dt command
    Also, better to make an overview via
        https://wiki.postgresql.org/wiki/Index_Maintenance
*/

SELECT s.schemaname,
       s.relname AS tablename,
       s.indexrelname AS indexname,
       pg_size_pretty(pg_relation_size(s.indexrelid::regclass)) AS index_size,
       idx_tup_read,
       idx_tup_fetch,
       idx_scan
FROM pg_catalog.pg_stat_user_indexes s
   JOIN pg_catalog.pg_index i ON s.indexrelid = i.indexrelid
WHERE
  s.idx_scan = 0      					-- has never been scanned
  AND 0 <>ALL (i.indkey)  				-- no index column is an expression
  AND NOT i.indisunique  				-- is not a UNIQUE index
  AND NOT EXISTS          				-- does not enforce a constraint
         (SELECT 1 FROM pg_catalog.pg_constraint c
          WHERE c.conindid = s.indexrelid)
ORDER BY pg_relation_size(s.indexrelid) DESC
LIMIT 30;