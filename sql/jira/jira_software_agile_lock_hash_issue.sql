/*
    * JIRA Agile Lock Hash Issue
    [c.a.g.service.lexorank.LexoRankOperation] Failed to acquire a lock on the max marker row and previous row for rank field[id=xxx], retrying rank initially
 */
SELECT COUNT("ID")
FROM "AO_60DB71_LEXORANK"
WHERE "LOCK_HASH" is NOT NULL
  AND "TYPE" in ('0', '2');


-- fix of solution
UPDATE "AO_60DB71_LEXORANK"
SET "LOCK_HASH" = NULL,
    "LOCK_TIME" = NULL;

-- then rebalance Lexorank