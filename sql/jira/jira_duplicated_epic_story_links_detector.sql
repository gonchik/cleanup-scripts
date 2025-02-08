/*
     duplicate epic-story link
    link: https://confluence.atlassian.com/jirakb/duplicate-epic-story-link-types-in-issuelinktype-table-causing-errors-in-search-using-has-epic-779158623.html
    if you see more that 1 rows - something wrong

     https://jira.atlassian.com/browse/JSWSERVER-10243

 */

SELECT *
FROM issuelinktype
WHERE linkname = 'Epic-Story Link';


/*
    Additional steps for locked duplicated fields
 */
CREATE TABLE BACKUP_managedconfigurationitem AS
SELECT *
FROM managedconfigurationitem
where access_level like 'LOCKED';



UPDATE managedconfigurationitem
set managed='false'
where item_id in (select item_id FROM managedconfigurationitem where access_level like 'LOCKED');


UPDATE managedconfigurationitem
set managed='true'
where item_id in (select item_id FROM managedconfigurationitem where access_level like 'LOCKED');
