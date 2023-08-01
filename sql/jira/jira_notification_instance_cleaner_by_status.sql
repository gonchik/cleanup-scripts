-- Delete references to closed issues  and NOT updated last 4 week
SELECT count(*)
FROM notificationinstance
WHERE SOURCE IN (SELECT ID
                 FROM jiraissue
                 where issuestatus in (SELECT id
                                       FROM issuestatus
                                       WHERE pname in ('Closed', 'Done', 'Rejected', 'Declined'))
                   AND UPDATED < (NOW() - '4 WEEK'));

/*
DELETE
FROM notificationinstance
WHERE SOURCE IN ( SELECT ID
                  FROM jiraissue
                  where issuestatus in (SELECT id
                                        FROM issuestatus
                                        WHERE pname in ('Closed', 'Done', 'Rejected', 'Declined') )
                    AND UPDATED < (NOW() -  '4 WEEK'));
*/

