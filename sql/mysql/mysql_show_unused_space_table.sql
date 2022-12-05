/*
    Get possible optimization
 */
select table_name, round(data_length/1024/1024) as DATA_LENGTH_MB, round(data_free/1024/1024) as DATA_FREE_MB
from information_schema.tables
where table_schema='<schema_name>'
order by data_free desc;

