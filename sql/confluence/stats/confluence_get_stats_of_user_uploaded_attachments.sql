-- Get stats of uploaded attachments by user
SELECT u.lower_username,
       SUM(cp.longval)/1024 AS "Size in KB"
FROM CONTENT c1
	JOIN CONTENT c2 ON c1.CONTENTID = c2.PAGEID
	JOIN user_mapping u ON c1.creator=u.user_key
	JOIN CONTENTPROPERTIES cp ON c2.CONTENTID = cp.CONTENTID
WHERE c2.contenttype='ATTACHMENT'
GROUP BY u.lower_username
ORDER BY 2 DESC
LIMIT 5;