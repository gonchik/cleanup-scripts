/*
    How many tickets has  exact issue link types in Jira per projects
 */

SELECT p.pkey, ist.linkname, count(ist.linkname)
FROM jiraissue ji
         INNER JOIN issuelink il ON il.source = ji.id
         INNER JOIN project p ON ji.project = p.id
         INNER JOIN issuelinktype ist on ist.id = il.linktype
GROUP BY  p.id, ist.linkname
ORDER BY 1, 2, 3;

