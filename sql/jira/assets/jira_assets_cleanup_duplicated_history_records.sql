/*
    Author: Artem Tumanov <demoncthulhu@gmail.com>, Gonchik Tsymzhitov
    Description: This script is used to REMOVE duplicated history records in Assets for Jira.
    Remove only duplicated 1000 records oldest in a batch.
    It works only for PostgreSQL.
 */


-- Optimized query
WITH sorted_history AS (
    SELECT 
        hist."ID",
        hist."OBJECT_ID",
        hist."AFFECTED_ATTRIBUTE",
        hist."NEW_VALUE",
        hist."OLD_VALUE",
        hist."CREATED",
        LEAD(hist."NEW_VALUE", 1) OVER (
            PARTITION BY hist."OBJECT_ID", hist."AFFECTED_ATTRIBUTE" 
            ORDER BY hist."CREATED" 
            ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
        ) AS next_new_value,
        LEAD(hist."OLD_VALUE", 1) OVER (
            PARTITION BY hist."OBJECT_ID", hist."AFFECTED_ATTRIBUTE" 
            ORDER BY hist."CREATED" 
            ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
        ) AS next_old_value
    FROM public."AO_8542F1_IFJ_OBJ_HIST" hist
    WHERE hist."CREATED" >= NOW() - INTERVAL '1 month'
),
matches AS (
    SELECT *, 'equal_rows' AS "Type"
    FROM sorted_history 
    WHERE "NEW_VALUE" = next_new_value AND "OLD_VALUE" = next_old_value
),
matches_2 AS (
    SELECT *, 'switch_old_new' AS "Type"
    FROM sorted_history 
    WHERE "OLD_VALUE" = next_new_value 
      AND "NEW_VALUE" = next_old_value 
      AND "NEW_VALUE" != ''
),
matches_3 AS (
    SELECT *, 'old_eq_new' AS "Type" 
    FROM sorted_history 
    WHERE "OLD_VALUE" = "NEW_VALUE" 
      AND "NEW_VALUE" != ''
),
all_match AS (
    SELECT * FROM matches 
    UNION ALL 
    SELECT * FROM matches_2 
    UNION ALL 
    SELECT * FROM matches_3
),
ranked_matches AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY "OBJECT_ID", "AFFECTED_ATTRIBUTE", "Type" 
            ORDER BY "CREATED" DESC
        ) AS rn
    FROM all_match
),
del_ids AS (
    SELECT "ID" 
    FROM ranked_matches 
    WHERE rn > 1  -- Keep first (most recent) record
    ORDER BY "ID" 
    LIMIT 1000  -- Batch size
)
DELETE FROM public."AO_8542F1_IFJ_OBJ_HIST"
WHERE "ID" IN (SELECT "ID" FROM del_ids);
