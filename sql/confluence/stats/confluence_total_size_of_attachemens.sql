-- Get total size of attachments in each space

SELECT s.spaceid,
       s.spacename,
       round(sum(LONGVAL)/1024)
FROM CONTENTPROPERTIES c
JOIN CONTENT co ON c.contentid = co.contentid
JOIN SPACES s ON co.spaceid = s.spaceid
WHERE c.contentid IN
    (SELECT contentid
     FROM CONTENT
     WHERE contenttype = 'ATTACHMENT')
  AND c.propertyname = 'FILESIZE'
GROUP BY s.spaceid
ORDER BY 3 DESC
LIMIT 5;