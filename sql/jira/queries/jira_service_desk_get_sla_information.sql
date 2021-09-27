/*
    Get Goals and SLA in one table across all products

*/

-- SELECT * FROM "AO_54307E_TIMEMETRIC";

SELECT
		vp."NAME" as "Portal Name",
		tm."NAME" as "SLA Name",
		g."JQL_QUERY",
		cal."NAME" as "Calendar",
		g."TARGET_DURATION"/1000/3600 as "Duration in h"
FROM
"AO_54307E_GOAL" g,
"AO_54307E_TIMEMETRIC" tm,
"AO_54307E_VIEWPORT" vp,
"AO_7A2604_CALENDAR" cal

WHERE
		g."CALENDAR_ID" = cal."ID"
	and g."TIME_METRIC_ID" = tm."ID"
	and tm."SERVICE_DESK_ID" = vp."ID"
	;
 1000/3600 as "Duration in h"
FROM
"AO_54307E_GOAL" g,
"AO_54307E_TIMEMETRIC" tm,
"AO_54307E_VIEWPORT" vp,
"AO_7A2604_CALENDAR" cal

WHERE
		g."CALENDAR_ID" = cal."ID"
	and g."TIME_METRIC_ID" = tm."ID"
	and tm."SERVICE_DESK_ID" = vp."ID"
	;
