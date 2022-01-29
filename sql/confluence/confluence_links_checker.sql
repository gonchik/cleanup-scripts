/*
  How to report on links in a Confluence instance
  Purpose: For auditing purposes, you may wish to see what links are being used
            on each page within a Confluence instance.
  Link: https://confluence.atlassian.com/confkb/how-to-report-on-links-in-a-confluence-instance-795936565.html
 */


SELECT s.spacename as Space, c.title as Page, l.destspacekey as SpaceOrProtocol, l.destpagetitle as Destination
FROM LINKS l
    JOIN CONTENT c ON c.contentid = l.contentid
    JOIN SPACES s ON s.spaceid = c.spaceid
WHERE c.prevver IS NULL
ORDER BY l.destspacekey