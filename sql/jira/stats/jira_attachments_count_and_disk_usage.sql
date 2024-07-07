/*
    How to get attachment statistics from the database
    https://confluence.atlassian.com/jirakb/how-to-get-attachment-statistics-from-the-database-1295390327.html
 */
-- Get the number of attachments and disk usage (in MB) for all of Jira
SELECT COUNT(*), ROUND((SUM(filesize) / 1000000), 2) AS total_mb
FROM fileattachment;

-- Get the number of attachments and disk usage (in MB) for a project
SELECT COUNT(*), ROUND((SUM(fa.filesize) / 1000000), 2) AS total_mb
FROM fileattachment fa
         JOIN jiraissue ji ON ji.id = fa.issueid
         JOIN project p ON p.id = ji.project
WHERE p.pkey = 'PROJECT-KEY-HERE';

-- Get the number of attachments and disk usage (in MB) for an issue
SELECT COUNT(*), ROUND((SUM(fa.filesize) / 1000000), 2) AS total_mb
FROM fileattachment fa
         JOIN jiraissue ji ON ji.id = fa.issueid
         JOIN project p ON p.id = ji.project
WHERE p.pkey = 'PROJECT-KEY-HERE'
  AND ji.issuenum = 'ISSUE-NUMBER-HERE';


-- Find the largest 20 issues by number of attachments
SELECT CONCAT(p.pkey, '-', ji.issuenum) AS issue, COUNT(*), ROUND((SUM(fa.filesize) / 1000000), 2) AS total_mb
FROM fileattachment fa
         JOIN jiraissue ji ON ji.id = fa.issueid
         JOIN project p ON p.id = ji.project
GROUP BY p.pkey, ji.issuenum
ORDER BY (COUNT(*)) DESC LIMIT 20;

-- Find the largest 20 issues by disk usage
SELECT CONCAT(p.pkey, '-', ji.issuenum) AS issue, COUNT(*), ROUND((SUM(fa.filesize) / 1000000), 2) AS total_mb
FROM fileattachment fa
         JOIN jiraissue ji ON ji.id = fa.issueid
         JOIN project p ON p.id = ji.project
GROUP BY p.pkey, ji.issuenum
ORDER BY (SUM(fa.filesize)) DESC LIMIT 20;

-- Find the largest 20 projects by number of attachments
SELECT p.pkey, p.pname, COUNT(*), ROUND((SUM(fa.filesize) / 1000000), 2) AS total_mb
FROM fileattachment fa
         JOIN jiraissue ji ON ji.id = fa.issueid
         JOIN project p ON p.id = ji.project
GROUP BY p.pkey, p.pname
ORDER BY (COUNT(*)) DESC LIMIT 20;

-- Find the largest 20 projects by disk usage
SELECT p.pkey, p.pname, COUNT(*), ROUND((SUM(fa.filesize) / 1000000), 2) AS total_mb
FROM fileattachment fa
         JOIN jiraissue ji ON ji.id = fa.issueid
         JOIN project p ON p.id = ji.project
GROUP BY p.pkey, p.pname
ORDER BY (SUM(fa.filesize)) DESC LIMIT 20;