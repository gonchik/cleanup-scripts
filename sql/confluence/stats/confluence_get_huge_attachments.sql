-- Get list of huge attachments

SELECT DISTINCT c.CONTENTID,
                c.TITLE AS attachmentTitle,
                u.USERNAME AS uploadedBy,
                co.TITLE AS pageTitle,
                round(cn.LONGVAL/1024/1024) AS MBytes
FROM CONTENT AS c
JOIN user_mapping AS u ON u.user_key = c.creator
JOIN CONTENT AS co ON c.pageid = co.contentid
JOIN CONTENTPROPERTIES AS cn ON cn.contentid = c.contentid
WHERE c.contenttype = 'ATTACHMENT'
	 AND cn.longval IS NOT NULL
ORDER BY cn.longval DESC
LIMIT 5;

