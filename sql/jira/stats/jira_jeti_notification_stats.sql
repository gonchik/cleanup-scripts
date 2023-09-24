/*
    Provide stats of notification from Jira project to end users via JETI app (Email This Issue plugin).
    Recommended adjust the dates.
 */

SELECT to_char(DATE_TRUNC('month', notif."SEND_TIME_STAMP"), 'YYYY-MM') as "Date",
       p.pkey                                                           as "Project",
       it.pname                                                         as "Issue Type",
       count(notif."ISSUE_KEY")                                         as "Notifications Number"
FROM "AO_544E33_AUDIT_LOG_ENTRY" notif
         JOIN jiraissue ji on notif."ISSUE_KEY" =
                              CONCAT((select pro.pkey from project pro where ji.project = pro.id), '-', ji.issuenum)
         INNER JOIN project p ON ji.project = p.id
         INNER JOIN issuetype it ON it.id = ji.issuetype
WHERE notif."SEND_TIME_STAMP" > '2023-01-01'
  AND notif."SEND_TIME_STAMP" < '2023-06-01'
GROUP BY DATE_TRUNC('month', notif."SEND_TIME_STAMP"), p.pkey, it.pname;