/*
    Cannot upload SQL files to JIRA on Windows
    error: java.lang.IllegalArgumentException: Error parsing media type 'text\plain'
    link: https://confluence.atlassian.com/jirakb/cannot-upload-sql-files-to-jira-on-windows-282173924.html
 */

select *
from fileattachment
where filename like '%.sql'
  and mimetype = 'text\plain';


-- fix
update fileattachment
set mimetype = 'text/plain'
where filename like '%.sql'
  and mimetype = 'text\plain';
