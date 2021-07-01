-- Count number of email references
SELECT count(ID)
FROM notificationinstance;

SET SQL_SAFE_UPDATES=0;
-- Delete unassociated messageID without references to tickets
DELETE
FROM notificationinstance
where SOURCE not in (SELECT ID from jiraissue);

-- Delete references to issues with resolution and NOT updated last 12 week */
DELETE
FROM notificationinstance
where SOURCE IN (   SELECT ID
					from jiraissue
                    where RESOLUTION is not null and
						UPDATED < (NOW() - INTERVAL 12 WEEK)
					);

-- Delete references to closed issues  and NOT updated last 4 week
DELETE
FROM notificationinstance
where SOURCE IN ( SELECT ID
				  FROM jiraissue
				  where issuestatus in (SELECT id
										FROM issuestatus
										where pname in ('Closed', 'Done') )
						AND UPDATED < (NOW() - INTERVAL 4 WEEK));

-- Remove empty MESSAGEID rows
DELETE FROM notificationinstance
where messageid like '';


-- Check duplicates of MessageID
SELECT SOURCE, MESSAGEID, COUNT(MESSAGEID)
FROM notificationinstance
GROUP BY MESSAGEID
HAVING COUNT(MESSAGEID) > 1
LIMIT 10;



-- Remove duplicated MESSAGEID rows, keep lowest id
DELETE n1
FROM notificationinstance n1,
notificationinstance n2
WHERE n1.id > n2.id
AND n1.MESSAGEID = n2.MESSAGEID;