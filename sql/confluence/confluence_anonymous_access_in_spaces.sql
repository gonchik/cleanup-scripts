/*
    How to get a list of spaces that are accessible by anonymous users

    To get a list of spaces that are accessible by anonymous users, from the database.
    url: https://support.atlassian.com/confluence/kb/how-to-get-a-list-of-spaces-that-are-accessible-by-anonymous-users/
 */

SELECT SPACENAME
FROM SPACES
WHERE SPACEID IN (SELECT SPACEID
                  FROM SPACEPERMISSIONS
                  WHERE PERMTYPE = 'VIEWSPACE'
                    AND PERMGROUPNAME IS NULL
                    AND PERMUSERNAME IS NULL
                    AND PERMALLUSERSSUBJECT IS NULL);
