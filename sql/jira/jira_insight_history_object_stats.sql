-- Get Insight history attributes for the retention policy

SELECT hist."AFFECTED_ATTRIBUTE",
       count(hist."ID")  updates
FROM "AO_8542F1_IFJ_OBJ_HIST" hist
GROUP BY hist."AFFECTED_ATTRIBUTE"
ORDER BY updates DESC;

-- only ID aggregated
SELECT hist."ID",
       count(hist."ID")  updates
FROM "AO_8542F1_IFJ_OBJ_HIST" hist
GROUP BY hist."ID"
ORDER BY updates DESC;

-- aggregated for both for small asset management
SELECT hist."ID",
       hist."AFFECTED_ATTRIBUTE",
       count(hist."ID")  updates
FROM "AO_8542F1_IFJ_OBJ_HIST" hist
GROUP BY hist."ID", hist."AFFECTED_ATTRIBUTE"
ORDER BY updates DESC;