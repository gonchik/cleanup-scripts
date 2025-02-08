/*
    How to change the RANK column in the AO_60DB71_LEXORANK table to the correct collation
    link: https://confluence.atlassian.com/jirakb/how-to-change-the-rank-column-in-the-ao_60db71_lexorank-table-to-the-correct-collation-779158613.html
 */

-- get Collation expected C or POSIX
show
LC_COLLATE;
show
LC_CTYPE;



select collation_name
from INFORMATION_SCHEMA.COLUMNS
where table_name = 'AO_60DB71_LEXORANK'
  and column_name = 'RANK';
