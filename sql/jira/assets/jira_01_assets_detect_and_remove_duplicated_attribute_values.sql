/*
 After running some Insight imports, some objects have duplicated or
 more attribute values on object attribute that should only allow exactly
 1 value (maximum cardinality = 1)

 link: https://jira.atlassian.com/browse/JSDSERVER-12010
 */
-- calculate how many values are duplicated
SELECT count("ID")
FROM "AO_8542F1_IFJ_OBJ_ATTR_VAL"
where "OBJECT_ATTRIBUTE_ID" in (SELECT min(OA2."ID") AS TO_DELETE
                                FROM "AO_8542F1_IFJ_OBJ_ATTR" OA2
                                         RIGHT JOIN (SELECT OTA."ID"       as OTA_ID,
                                                            OTA."NAME",
                                                            OA."OBJECT_ID" as OA_OID,
                                                            count(*)
                                                     FROM "AO_8542F1_IFJ_OBJ_TYPE_ATTR" OTA
                                                              LEFT JOIN "AO_8542F1_IFJ_OBJ_ATTR" OA ON OTA."ID" = OA."OBJECT_TYPE_ATTRIBUTE_ID"
                                                     GROUP BY OTA."ID", OTA."NAME", OA."OBJECT_ID"
                                                     HAVING count(*) > 1) AS SUBQ
                                                    ON OA2."OBJECT_TYPE_ATTRIBUTE_ID" = SUBQ.OTA_ID AND
                                                       OA2."OBJECT_ID" = SUBQ.OA_OID
                                GROUP BY OA2."OBJECT_ID", OA2."OBJECT_TYPE_ATTRIBUTE_ID");

-- delete duplicated values

DELETE
from "AO_8542F1_IFJ_OBJ_ATTR_VAL"
where "OBJECT_ATTRIBUTE_ID" in (SELECT min(OA2."ID") AS TO_DELETE
                                FROM "AO_8542F1_IFJ_OBJ_ATTR" OA2
                                         RIGHT JOIN (SELECT OTA."ID"       as OTA_ID,
                                                            OTA."NAME",
                                                            OA."OBJECT_ID" as OA_OID,
                                                            count(*)
                                                     FROM "AO_8542F1_IFJ_OBJ_TYPE_ATTR" OTA
                                                              LEFT JOIN "AO_8542F1_IFJ_OBJ_ATTR" OA ON OTA."ID" = OA."OBJECT_TYPE_ATTRIBUTE_ID"
                                                     GROUP BY OTA."ID", OTA."NAME", OA."OBJECT_ID"
                                                     HAVING count(*) > 1) AS SUBQ
                                                    ON OA2."OBJECT_TYPE_ATTRIBUTE_ID" = SUBQ.OTA_ID AND
                                                       OA2."OBJECT_ID" = SUBQ.OA_OID
                                GROUP BY OA2."OBJECT_ID", OA2."OBJECT_TYPE_ATTRIBUTE_ID");