/*
    MySQL query
    Broken URL in Notification Containing Plugins/Servlet/Undefined
    url: https://confluence.atlassian.com/confkb/broken-url-in-notification-containing-plugins-servlet-undefined-678561912.html
 */

SELECT TABLE_SCHEMA,
       TABLE_NAME,
       CCSA.CHARACTER_SET_NAME AS DEFAULT_CHAR_SET,
       COLUMN_NAME,
       COLUMN_TYPE,
       C.CHARACTER_SET_NAME,
       ENGINE
FROM information_schema.TABLES AS T
         JOIN information_schema.COLUMNS AS C USING (TABLE_SCHEMA, TABLE_NAME)
         JOIN information_schema.COLLATION_CHARACTER_SET_APPLICABILITY AS CCSA
              ON (T.TABLE_COLLATION = CCSA.COLLATION_NAME)
WHERE TABLE_SCHEMA = SCHEMA ()
  AND C.DATA_TYPE IN ('enum'
    , 'varchar'
    , 'char'
    , 'text'
    , 'mediumtext'
    , 'longtext')
ORDER BY TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME;