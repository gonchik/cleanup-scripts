/* Preparation to find orphan records*/

-- exist without links attachments
select count(*) from fileattachment where issueid not in (select id from jiraissue);

/*
    SELECT count(*)
    FROM fileattachment fa
    LEFT JOIN jiraissue ji
    ON fa.issueid = ji.id
    WHERE ji.id is null
*/

-- messageId collector table
select count(*) from notificationinstance where SOURCE not in (select id from jiraissue where id is not null);

-- lost comments
select count(*) from jiraaction where issueid not in (select id from jiraissue);

-- change item and group is history
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
SELECT count(*) FROM searchrequest WHERE authorname not in (select lower_user_name from cwd_user);


/* Delete orphan records*/
/* Disclaimer: easy to remove, time wasting to repair */
/* Please, check DB scheme before remove something */
/* That commands works well on 6.4.x and 7.x version, 8.x. */
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
delete FROM searchrequest WHERE authorname not in (select lower_user_name from cwd_user);

*/

-- https://jira.atlassian.com/browse/JSWSERVER-9906
select count(*) from AO_60DB71_ISSUERANKING  where  (ISSUE_ID >0) AND ISSUE_ID not in  (select id from jiraissue) ;
-- this should return none if the number of tails is right.
select count(*) from AO_60DB71_ISSUERANKING WHERE "NEXT_ID" IS NULL GROUP BY "CUSTOM_FIELD_ID" HAVING COUNT(*) > 1;

-- this should return none, otherwise you may have duplicate values on ISSUE_ID
select count("ISSUE_ID") FROM AO_60DB71_ISSUERANKING GROUP BY "ISSUE_ID", "CUSTOM_FIELD_ID" HAVING COUNT(*) > 1;

 -- this should return none, otherwise you may have duplicate values on NEXT_ID
select "NEXT_ID" FROM AO_60DB71_ISSUERANKING GROUP BY "NEXT_ID", "CUSTOM_FIELD_ID" HAVING COUNT(*) > 1;

-- delete from AO_60DB71_ISSUERANKING  where  (ISSUE_ID >0) AND ISSUE_ID not in  (select id from jiraissue) ;
