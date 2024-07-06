/*
     Querying attachments per issue key
     To retrieve the list of attachments and its corresponding issue keys.
     link: https://confluence.atlassian.com/jirakb/querying-attachments-per-issue-key-828794979.html

*/

select distinct p.pkey || '-' || j.issuenum, fa.filename
from project p,
     jiraissue j,
     fileattachment fa
where p.id = j.project
  and fa.issueid = j.id;
