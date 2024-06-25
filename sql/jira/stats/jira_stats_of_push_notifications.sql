/*

    Provide stats of push notifications
    Author: Gonchik Tsymzhitov

 */
SELECT to_char(DATE_TRUNC('month', notif."NOTIFICATION_DATE"), 'YYYY-MM'),
       p.pkey   as "Project",
       it.pname as "Issue Type",
       count(notif."ISSUE_KEY")
FROM "AO_248DF5_INOTIFICATION" notif
         JOIN jiraissue ji on notif."ISSUE_KEY" =
                              CONCAT((select pro.pkey from project pro where ji.project = pro.id), '-', ji.issuenum)
         INNER JOIN project p ON ji.project = p.id
         inner join issuetype it on it.id = ji.issuetype
group by DATE_TRUNC('month', notif."NOTIFICATION_DATE"), p.pkey, it.pname;