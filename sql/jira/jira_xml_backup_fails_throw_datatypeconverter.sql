/*
    JIRA XML Backup fails throws "java.lang.NoClassDefFoundError: javax/xml/bind/DatatypeConverter"

    Cause: An AO table has column with BLOB datatype. According to this documentation Developing your plugin with Active Objects, JIRA does not fully support BLOB datatype in AO.

 */

-- MySQL
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
where table_name like 'AO_%'
  and data_type = 'blob';


-- PostgreSQL
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE 'AO_%'
  AND DATA_TYPE = 'bytea';

-- MS SQL SERVER
SELECT DISTINCT ta.name                   AS table_name,
                SCHEMA_NAME(ta.schema_id) AS schema_name,
                c.name                    AS column_name,
                t.name                    AS data_type
FROM sys.tables AS ta
         INNER JOIN sys.columns c ON ta.OBJECT_ID = c.OBJECT_ID
         INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
WHERE ta.name like 'AO_%'
  and (t.name = 'image' OR t.name = 'varbinary');


-- Cleanup tables

DELETE
FROM < table_name >;
