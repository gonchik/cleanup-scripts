/*
    Finding Attachment Statistic in Jira

 */


SELECT p.pkey,
       p.pname,
       EXTRACT(YEAR FROM f.created)       yr,
       COUNT(f.id)                     AS "# of files",
       MIN(f.filesize) / 1024          AS "min size (kB)",
       AVG(f.filesize) / 1024          AS "average size(kB)",
       MAX(f.filesize) / 1024          AS "max size (kB)",
       SUM(f.filesize) / (1024 * 1024) AS "total size(mB)"
FROM fileattachment f,
     project p,
     jiraissue i
WHERE f.issueid = i.id
  AND i.project = p.id
GROUP BY p.pkey, p.pname, yr;