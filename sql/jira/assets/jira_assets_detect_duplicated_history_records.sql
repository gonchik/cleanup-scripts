/*
    Author: Artem Tumanov <demoncthulhu@gmail.com>
    Description: This script is used to detect duplicated history records in Assets for Jira.
    It works only for PostgreSQL.
 */

WITH sorted_history AS (SELECT hist."ID",
                               hist."OBJECT_ID",
                               hist."AFFECTED_ATTRIBUTE",
                               hist."NEW_VALUE",
                               hist."OLD_VALUE",
                               hist."CREATED",
                               LEAD(hist."NEW_VALUE") OVER (PARTITION BY hist."OBJECT_ID", hist."AFFECTED_ATTRIBUTE" ORDER BY hist."CREATED") AS next_new_value, LEAD(hist."OLD_VALUE") OVER (PARTITION BY hist."OBJECT_ID", hist."AFFECTED_ATTRIBUTE" ORDER BY hist."CREATED") AS next_old_value
                        FROM public."AO_8542F1_IFJ_OBJ_HIST" hist
                                 join public."AO_8542F1_IFJ_OBJ" afio on afio."ID" = hist."OBJECT_ID"
                                 join public."AO_8542F1_IFJ_OBJ_TYPE" afiot on afiot."ID" = afio."OBJECT_TYPE_ID"),
     matches AS (SELECT sh.*,
                        'equal rows' as "Type"
                 FROM sorted_history sh
                 WHERE (sh."NEW_VALUE" = sh.next_new_value
                     and sh."OLD_VALUE" = sh.next_old_value)),
     matches_2 AS (SELECT sh.*,
                          'switch old new rows' as "Type"
                   FROM sorted_history sh
                   WHERE sh."OLD_VALUE" = sh.next_new_value
                     and sh."NEW_VALUE" = sh.next_old_value
                     and sh."NEW_VALUE" != ''
    ), matches_3 AS (
SELECT
    sh.*, 'old = new' as "Type"
FROM
    sorted_history sh
WHERE
    sh."OLD_VALUE" = sh."NEW_VALUE"
  and sh."NEW_VALUE" != ''
    )
    , all_match AS (
select
    *
FROM
    matches
union
SELECT *
FROM matches_2
union
select
    *
FROM
    matches_3
    ), counts as (
select
    "OBJECT_ID", "AFFECTED_ATTRIBUTE", "Type", COUNT (*) AS match_count
FROM
    all_match
GROUP BY
    "OBJECT_ID",
    "AFFECTED_ATTRIBUTE",
    "Type"
HAVING
    COUNT (*)
     > 0
    )
     , ranked_matches AS (
select
    m.*, ROW_NUMBER() OVER (PARTITION BY m."OBJECT_ID", m."AFFECTED_ATTRIBUTE", m."Type" ORDER BY m."CREATED" DESC) AS rn
FROM
    all_match m
    JOIN
    counts c
ON m."OBJECT_ID" = c."OBJECT_ID")
select *
from ranked_matches;
