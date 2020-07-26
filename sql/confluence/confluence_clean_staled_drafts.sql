-- That script help you cleanup the draft pages and improve speedup of Synchrony
-- https://confluence.atlassian.com/confkb/how-to-manually-remove-stale-drafts-from-confluence-database-951392345.html
-- diagnostics
SELECT d.contentid, d.title, d.prevver, d.lastmoddate, c.lastmoddate
FROM CONTENT d
JOIN CONTENT c
  ON d.prevver = c.contentid
WHERE d.content_status = 'draft'
  AND d.prevver IS NOT NULL
  AND c.lastmoddate > d.lastmoddate;

-- action
SET SQL_SAFE_UPDATES=0;
DELETE FROM NOTIFICATIONS WHERE CONTENTID IN (SELECT d.contentid
FROM CONTENT d
JOIN CONTENT c
  ON d.prevver = c.contentid
WHERE d.content_status = 'draft'
  AND d.prevver IS NOT NULL
  AND c.lastmoddate > d.lastmoddate);

DELETE FROM CONFANCESTORS WHERE ANCESTORID IN (SELECT d.contentid
FROM CONTENT d
JOIN CONTENT c
  ON d.prevver = c.contentid
WHERE d.content_status = 'draft'
  AND d.prevver IS NOT NULL
  AND c.lastmoddate > d.lastmoddate);

DELETE FROM CONFANCESTORS WHERE DESCENDENTID IN (SELECT d.contentid
FROM CONTENT d
JOIN CONTENT c
  ON d.prevver = c.contentid
WHERE d.content_status = 'draft'
  AND d.prevver IS NOT NULL
  AND c.lastmoddate > d.lastmoddate);

DELETE FROM BODYCONTENT WHERE CONTENTID IN (SELECT d.contentid
FROM CONTENT d
JOIN CONTENT c
  ON d.prevver = c.contentid
WHERE d.content_status = 'draft'
  AND d.prevver IS NOT NULL
  AND c.lastmoddate > d.lastmoddate);

DELETE FROM CONTENTPROPERTIES WHERE CONTENTID IN (SELECT d.contentid
FROM CONTENT d
JOIN CONTENT c
  ON d.prevver = c.contentid
WHERE d.content_status = 'draft'
  AND d.prevver IS NOT NULL
  AND c.lastmoddate > d.lastmoddate);

DELETE FROM LINKS WHERE CONTENTID IN (SELECT d.contentid
FROM CONTENT d
JOIN CONTENT c
  ON d.prevver = c.contentid
WHERE d.content_status = 'draft'
  AND d.prevver IS NOT NULL
  AND c.lastmoddate > d.lastmoddate);

DELETE FROM CONTENT_LABEL WHERE contentid IN (SELECT d.contentid
FROM CONTENT d
JOIN CONTENT c
  ON d.prevver = c.contentid
WHERE d.content_status = 'draft'
  AND d.prevver IS NOT NULL
  AND c.lastmoddate > d.lastmoddate);

DELETE FROM usercontent_relation WHERE targetcontentid IN (SELECT d.contentid
FROM CONTENT d
JOIN CONTENT c
  ON d.prevver = c.contentid
WHERE d.content_status = 'draft'
  AND d.prevver IS NOT NULL
  AND c.lastmoddate > d.lastmoddate);

DELETE FROM extrnlnks WHERE CONTENTID IN (SELECT d.contentid
FROM CONTENT d JOIN CONTENT c
 ON d.prevver = c.contentid
WHERE d.content_status = 'draft'
 AND d.prevver IS NOT NULL
 AND c.lastmoddate > d.lastmoddate);

DELETE FROM likes WHERE CONTENTID IN (SELECT d.contentid
FROM CONTENT d
JOIN CONTENT c
  ON d.prevver = c.contentid
WHERE d.content_status = 'draft'
  AND d.prevver IS NOT NULL
  AND c.lastmoddate > d.lastmoddate);

DELETE FROM CONTENT WHERE CONTENTID IN (SELECT d.contentid
FROM CONTENT d
JOIN CONTENT c
  ON d.prevver = c.contentid
WHERE d.content_status = 'draft'
  AND d.prevver IS NOT NULL
  AND c.lastmoddate > d.lastmoddate);