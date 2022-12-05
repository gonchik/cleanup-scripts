-- Delete unassociated messageID without references to tickets

SELECT count(*)
FROM notificationinstance
WHERE SOURCE not in (SELECT ID from jiraissue);



/*
DELETE
FROM notificationinstance
where SOURCE not in (SELECT ID from jiraissue);
*/