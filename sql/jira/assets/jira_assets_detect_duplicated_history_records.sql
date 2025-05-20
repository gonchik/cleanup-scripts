/*
    Author: Artem Tumanov <demoncthulhu@gmail.com>
    Description: This script is used to detect duplicated history records in Assets for Jira.
    It works only for PostgreSQL.
 */
 
-- Recommended indexes (execute separately first)
-- CREATE INDEX idx_hist_partition ON public."AO_8542F1_IFJ_OBJ_HIST"("OBJECT_ID","AFFECTED_ATTRIBUTE","CREATED");
-- CREATE INDEX idx_hist_values ON public."AO_8542F1_IFJ_OBJ_HIST"("NEW_VALUE","OLD_VALUE");

WITH sorted_history AS (
    SELECT 
        hist."ID",
        hist."OBJECT_ID",
        hist."AFFECTED_ATTRIBUTE",
        hist."NEW_VALUE",
        hist."OLD_VALUE",
        hist."CREATED",
        LEAD(hist."NEW_VALUE", 1) OVER (
            PARTITION BY hist."OBJECT_ID", hist."AFFECTED_ATTRIBUTE 
            ORDER BY hist."CREATED" 
            ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
        ) AS next_new_value,
        LEAD(hist."OLD_VALUE", 1) OVER (
            PARTITION BY hist."OBJECT_ID", hist."AFFECTED_ATTRIBUTE 
            ORDER BY hist."CREATED" 
            ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
        ) AS next_old_value
    FROM public."AO_8542F1_IFJ_OBJ_HIST" hist
),
matches AS (
    SELECT *, 'equal_rows' AS "Type"
    FROM sorted_history 
    WHERE "NEW_VALUE" = next_new_value 
      AND "OLD_VALUE" = next_old_value
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
)
SELECT count(*)
FROM ranked_matches;


