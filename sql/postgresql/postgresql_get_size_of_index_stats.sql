/*
 *
 *   Get stats of your DB indexes.
 *   Interesting to understand which indexes is not used on your instance.
 *   After you can easier review tables via \dt command
 *   Also, better to make an overview via
 *       https://wiki.postgresql.org/wiki/Index_Maintenance
*/

SELECT s.schemaname,
       s.relname                                                AS tablename,
       s.indexrelname                                           AS indexname,
       pg_size_pretty(pg_relation_size(s.indexrelid::regclass)) AS index_size,
       psut.idx_scan,
       psut.seq_scan,
       CASE
           WHEN (psut.seq_scan + psut.idx_scan) = 0 THEN
               0
           ELSE
               (100 * psut.idx_scan / (psut.seq_scan + psut.idx_scan))
           END                                                  AS percent_of_times_index_used
FROM pg_catalog.pg_stat_user_indexes s
         LEFT JOIN pg_stat_user_tables AS psut ON psut.relid = s.relid
         JOIN pg_catalog.pg_index i ON s.indexrelid = i.indexrelid
WHERE s.idx_scan = 0      -- has never been scanned
  AND 0 <> ALL (i.indkey) -- no index column is an expression
  AND NOT i.indisunique   -- is not a UNIQUE index
  AND NOT EXISTS -- does not enforce a constraint
    (SELECT 1
     FROM pg_catalog.pg_constraint c
     WHERE c.conindid = s.indexrelid)
ORDER BY pg_relation_size(s.indexrelid) DESC
;