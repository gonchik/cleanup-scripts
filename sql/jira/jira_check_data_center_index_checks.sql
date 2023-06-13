/*

    Checks index mismatch
    link: https://confluence.atlassian.com/jirakb/upgrading-from-8-x-to-9-x-index-changes-1168845946.html

*/


--- number of unversioned issues
select count(*)
FROM jiraissue
         LEFT JOIN issue_version ON issue_version.issue_id = jiraissue.id
         WHERE issue_version.issue_id is null;


--- number of unversioned worklogs
SELECT count(*)
FROM worklog
        LEFT JOIN worklog_version on worklog_version.worklog_id = worklog.id
        WHERE worklog_version.worklog_id is null;


--- number of unversioned comments
SELECT count(*)
FROM jiraaction
        LEFT JOIN comment_version ON comment_version.comment_id = jiraaction.id
        WHERE actiontype = 'comment'  AND comment_version.comment_id is null;
