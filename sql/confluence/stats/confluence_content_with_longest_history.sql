-- Get content with longest history

SELECT title,
	   -- CONTENTID,
       MAX(VERSION)
FROM CONTENT
WHERE contenttype = 'PAGE'
GROUP BY title
ORDER BY 2 DESC
LIMIT 5;