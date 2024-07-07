/*
    link: https://confluence.atlassian.com/jirakb/querying-attachments-per-file-type-1319575950.html
 */

SELECT fa.id, fa.filename, p.pkey, ji.issuenum
FROM fileattachment fa
         join jiraissue ji on ji.id = fa.issueid
         join project p on p.id = ji.project
WHERE LOWER(fa.filename) LIKE '%.png';


-- Find by mime-type
-- https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types
SELECT fa.id, fa.filename, p.pkey, ji.issuenum
FROM fileattachment fa
         join jiraissue ji on ji.id = fa.issueid
         join project p on p.id = ji.project
WHERE fa.mimetype LIKE  'image/png';