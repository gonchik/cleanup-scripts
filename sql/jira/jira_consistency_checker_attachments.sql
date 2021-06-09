/*
    XXX-#### can not be opened. The issue may have been deleted or you might not have permission to see the issue.
    https://confluence.atlassian.com/jirakb/issue-can-not-be-opened-error-when-trying-to-select-it-in-the-issue-navigator-376832648.html
*/
select * from fileattachment where created is null;

-- update fileattachment set created = now() where created is null;