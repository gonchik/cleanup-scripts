/*

  Outline a scenario in which users seek to retrieve attachment details
  from Jira tickets for a customizable duration of time, be it days or months.
  title: SQL query to get the details of attachments uploaded in Jira issues for configurable number of days or months.
  link: https://confluence.atlassian.com/jirakb/sql-query-to-get-the-details-of-attachments-uploaded-in-jira-issues-for-configurable-number-of-days-or-months-1305249650.html
 */
select fa.id,
       fa.filename,
       p.pkey as project,
       ji.issuenum
from fileattachment fa
         join jiraissue ji on
    ji.id = fa.issueid
         join project p on
    p.id = ji.project
where fa.created > '2023-10-17 07:55';