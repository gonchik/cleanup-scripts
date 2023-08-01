-- Check duplicates of MessageID


SELECT SOURCE, MESSAGEID, COUNT(MESSAGEID)
FROM notificationinstance
GROUP BY MESSAGEID
HAVING COUNT(MESSAGEID) > 1
ORDER BY 3 DESC LIMIT 10;


-- Remove duplicated MESSAGEID rows, keep lowest id
DELETE
n1
FROM notificationinstance n1,
notificationinstance n2
WHERE n1.id > n2.id
AND n1.MESSAGEID = n2.MESSAGEID;