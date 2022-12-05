/*
    Count number of email references for tickets with resolution
 */
SELECT count(ID)
FROM notificationinstance
WHERE SOURCE in (select id from jiraissue where RESOLUTION is not null);


/*
    Delete messageid for tickets with resolution
 */

-- for MySQL
-- SET SQL_SAFE_UPDATES=0;

DELETE
FROM notificationinstance
WHERE SOURCE in (select id from jiraissue where RESOLUTION is not null);

