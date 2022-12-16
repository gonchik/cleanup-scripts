/*
   Jira is trying to do index recovery on invalid issue data coming from Lucene indexes
   Purpose: Check issue number null tickets
   Ticket: https://jira.atlassian.com/browse/JRASERVER-70248
   Link: https://confluence.atlassian.com/jirakb/full-reindex-failing-at-100-with-1-error-in-jira-1047548462.html
*/

SELECT id,issuenum,project FROM jiraissue WHERE issuenum IS null;

-- fix possible problem
DELETE FROM jiraissue WHERE issuenum IS NULL;
