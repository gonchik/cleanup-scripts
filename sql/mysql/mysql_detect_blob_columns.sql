/*
    Large objects in MySQL are columns with following data types: blob, mediumblob, longblob, text, mediumtext, and longtext.
 */

select tab.table_name,
       count(*) as columns
from information_schema.tables as tab
         inner join information_schema.columns as col
                    on col.table_schema = tab.table_schema
                        and col.table_name = tab.table_name
                        and col.data_type in ('blob', 'mediumblob', 'longblob',
                                              'text', 'mediumtext', 'longtext')
where tab.table_schema = 'your database name'
  and tab.table_type = 'BASE TABLE'
group by tab.table_name
order by tab.table_name;