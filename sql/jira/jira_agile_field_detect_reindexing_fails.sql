-- Reindexing fails with expected exactly 2 rows error in Jira server
-- https://confluence.atlassian.com/jirakb/reindexing-fails-with-expected-exactly-2-rows-error-in-jira-server-779158916.html

SELECT "FIELD_ID",
  "TYPE",
  substring("RANK" FROM 1 FOR 1) AS bucket
FROM "AO_60DB71_LEXORANK"
WHERE "TYPE" IN (0, 2);


-- Oracle DB
/*
SELECT
  "FIELD_ID",
  "TYPE",
  SUBSTR("RANK", 1, 1) AS bucket
FROM "AO_60DB71_LEXORANK"
WHERE "TYPE" IN (0, 2);
*/

-- MICROSOFT SQL SERVER
/*
SELECT
  "FIELD_ID",
  "TYPE",
  SUBSTRING("RANK", 1, 1) AS bucket
FROM "dbo.AO_60DB71_LEXORANK"
WHERE "TYPE" IN (0, 2);
*/


--
SELECT propertyvalue
FROM propertyentry
  LEFT JOIN propertynumber ON propertyentry.ID = propertynumber.ID
WHERE property_key = 'GreenHopper.LexoRank.Default.customfield.id';

-- IndexingFailureException thrown during reindex of Jira server
-- https://confluence.atlassian.com/jirakb/indexingfailureexception-thrown-during-reindex-of-jira-server-779158905.html
SELECT "ISSUE_ID"
FROM "AO_60DB71_LEXORANK"
WHERE "FIELD_ID" = <Rank_Custom_Field_ID>
GROUP BY "ISSUE_ID"
HAVING count("ISSUE_ID") > 1;


/*
  DELETE from "AO_60DB71_LEXORANK" WHERE "ID" in (
  WITH temp AS (
  SELECT  "ID", "ISSUE_ID", ROW_NUMBER()
  OVER ( PARTITION BY "ISSUE_ID" ORDER BY "ISSUE_ID" )
  from "AO_60DB71_LEXORANK" WHERE "ISSUE_ID" in
 (SELECT "ISSUE_ID" from "AO_60DB71_LEXORANK" WHERE "FIELD_ID" = <Rank Custom Field ID> GROUP BY "ISSUE_ID" HAVING count("ISSUE_ID") > 1))
  select "ID" from temp where row_number = 1 ) ;
 */