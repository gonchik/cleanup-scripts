/*
     Querying attachments per issue key
     To retrieve the list of attachments and its corresponding issue keys.
     link: https://confluence.atlassian.com/jirakb/querying-attachments-per-issue-key-828794979.html

*/

SELECT DISTINCT p.pkey || '-' || j.issuenum, fa.filename
FROM project p,
     jiraissue j,
     fileattachment fa
WHERE p.id = j.project
  AND fa.issueid = j.id;
