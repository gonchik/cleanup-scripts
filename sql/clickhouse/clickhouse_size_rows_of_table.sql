/*
    Get compressed, uncompressed, rows of tables
    i.e. sandbox.gonchik
 */
SELECT database,
       table,
       formatReadableSize(size)     as size,
       formatReadableSize(dub)      as size_uncompressed,
       formatReadableQuantity(rows) as rows
FROM (
         SELECT table,
                sum(bytes)                   AS size,
                sum(bytes_on_disk)           AS size_ondisk,
                sum(data_compressed_bytes)   AS dcb,
                sum(data_uncompressed_bytes) AS dub,
                sum(rows)                    AS rows,
                database
         FROM system.parts
         WHERE 1
           and active
           and database in ['sandbox' ]
           and position(lower(table), 'gonchik')
         GROUP BY database, table
         ORDER BY size_ondisk DESC
         );