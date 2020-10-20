-- Get number of content in each space
SELECT COUNT(c.contentid) AS number_of_trashed_pages,
       (SUM(LENGTH(b.BODY))) AS trash_total_size,
       s.SPACENAME AS space_name
FROM BODYCONTENT b
	INNER JOIN CONTENT c ON (c.CONTENTID = b.CONTENTID)
	INNER JOIN SPACES s ON (c.SPACEID = s.SPACEID)
WHERE b.CONTENTID IN
			(SELECT CONTENTID
            FROM CONTENT
            WHERE content_status = 'deleted'
            AND contenttype = 'PAGE')
GROUP BY space_name
ORDER BY trash_total_size
LIMIT 5;
