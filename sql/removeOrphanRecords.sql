/* Preparation to find orphan records*/
select count(*) from fileattachment where issueid not in(select id from jiraissue);
select count(*) from notificationinstance where SOURCE not in (select id from jiraissue);
select count(*) from jiraaction where issueid not in (select id from jiraissue);
select count(*) from changegroup where issueid not in (select id from jiraissue);
select count(*) from changeitem where groupid not in (select id from changegroup);
select count(*) from OS_CURRENTSTEP where ENTRY_ID not in (select WORKFLOW_ID from jiraissue);
select count(*) from OS_HISTORYSTEP where ENTRY_ID not in (select WORKFLOW_ID from jiraissue);
select count(*) from worklog where issueid not in (select ID from jiraissue);
select count(*) from customfieldvalue where issue not in (select ID from jiraissue);
select count(*) from nodeassociation where (source_node_entity = 'Issue') AND (SOURCE_NODE_ID not in (select id from jiraissue));
select count(*) from userassociation where (sink_node_entity = 'Issue') AND (sink_node_id not in (select id from jiraissue));
select count(*) from issuelink where source not in (select id from jiraissue);
select count(*) from issuelink where destination not in (select id from jiraissue);




/* Delete orphan records*/
/* Disclaimer: easy to remove, time wasting to repair */
/* Please, check DB scheme before remove something */
/* That commands works well on 6.4.x and 7.x version. */
/*
SET SQL_SAFE_UPDATES=0;
delete from fileattachment where issueID not in(select ID from jiraissue);
delete from notificationinstance where SOURCE not in (select ID from jiraissue);
delete from jiraaction where issueID not in (select ID from jiraissue);
delete from changegroup where issueID not in (select ID from jiraissue);
delete from changeitem where groupID not in (select ID from changegroup);
delete from OS_CURRENTSTEP where ENTRY_ID not in (select WORKFLOW_ID from jiraissue);
delete from OS_HISTORYSTEP where ENTRY_ID not in (select WORKFLOW_ID from jiraissue);
delete from worklog where issueID not in (select ID from jiraissue);
delete from customfieldvalue where issue not in (select ID from jiraissue);
delete from nodeassociation where (source_node_entity = 'Issue') AND (SOURCE_NODE_ID not in (select ID from jiraissue));
delete from userassociation where (sink_node_entity = 'Issue') AND (sink_node_ID not in (select ID from jiraissue));
delete from issuelink where source not in (select ID from jiraissue);
delete from issuelink where destination not in (select ID from jiraissue);
*/