-- That query just to make review of duplicated fields
-- as waiting that request https://jira.atlassian.com/browse/JRASERVER-61376
-- Motivation based on the UX and continuous of mistakes in scripts, add-ons etc.

SELECT ID, cfname, CUSTOMFIELDTYPEKEY
FROM customfield
WHERE UPPER(cfname) IN
      (SELECT UPPER(cfname)
       FROM customfield
       GROUP BY UPPER(cfname)
       HAVING COUNT(*) > 1)
ORDER BY cfname;