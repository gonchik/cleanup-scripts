-- Get Insight history attributes for the retention policy

SELECT hist."AFFECTED_ATTRIBUTE", count(hist."ID")  updates
FROM "AO_8542F1_IFJ_OBJ_HIST" hist
GROUP BY hist."AFFECTED_ATTRIBUTE"
ORDER BY updates DESC;