/*
    Find objects and object type attributes with database scripts
    url: https://confluence.atlassian.com/insightapps/find-objects-and-object-type-attributes-with-database-scripts-1085191244.html
*/

-- Same value multiple times
SELECT
    O."ID",
    OTA."NAME",
    OA."ID",
    OA."OBJECT_TYPE_ATTRIBUTE_ID",
    OA."OBJECT_ID",
    count(OAV."ID"),
    OAV."TEXT_VALUE",
    OAV."INTEGER_VALUE",
    OAV."BOOLEAN_VALUE",
    OAV."DATE_VALUE",
    OAV."REFERENCED_OBJECT_ID"
FROM "AO_8542F1_IFJ_OBJ" O
         LEFT OUTER JOIN "AO_8542F1_IFJ_OBJ_ATTR" OA ON O."ID" = OA."OBJECT_ID"
         LEFT OUTER JOIN "AO_8542F1_IFJ_OBJ_TYPE_ATTR" OTA ON OTA."ID" = OA."OBJECT_TYPE_ATTRIBUTE_ID"
         LEFT OUTER JOIN "AO_8542F1_IFJ_OBJ_ATTR_VAL" OAV ON OA."ID" = OAV."OBJECT_ATTRIBUTE_ID"
GROUP BY O."ID", OTA."NAME", OA."ID", OA."OBJECT_TYPE_ATTRIBUTE_ID", OA."OBJECT_ID", OAV."TEXT_VALUE",
         OAV."INTEGER_VALUE", OAV."BOOLEAN_VALUE", OAV."DATE_VALUE", OAV."REFERENCED_OBJECT_ID"
HAVING count(OAV."ID") > 1;


-- Maximum cardinality violation (find objects)
SELECT
    O."ID",
    O."OBJECT_KEY",
    O."LABEL"
FROM "AO_8542F1_IFJ_OBJ" O
         LEFT OUTER JOIN "AO_8542F1_IFJ_OBJ_ATTR" OA ON O."ID" = OA."OBJECT_ID"
WHERE OA."ID" IN (SELECT OA."ID"
                  FROM "AO_8542F1_IFJ_OBJ_ATTR" OA
                           LEFT OUTER JOIN "AO_8542F1_IFJ_OBJ_TYPE_ATTR" OTA ON OTA."ID" = OA."OBJECT_TYPE_ATTRIBUTE_ID"
                           LEFT OUTER JOIN "AO_8542F1_IFJ_OBJ_ATTR_VAL" OAV ON OA."ID" = OAV."OBJECT_ATTRIBUTE_ID"
                  WHERE OTA."MAXIMUM_CARDINALITY" != -1
GROUP BY OTA."ID", OA."ID"
HAVING count(*) > OTA."MAXIMUM_CARDINALITY");

-- Maximum cardinality violation (find objects type attributes)
SELECT
    OTA."ID",
    OA."ID",
    count(*)
FROM "AO_8542F1_IFJ_OBJ_ATTR" OA
         LEFT OUTER JOIN "AO_8542F1_IFJ_OBJ_TYPE_ATTR" OTA ON OTA."ID" = OA."OBJECT_TYPE_ATTRIBUTE_ID"
         LEFT OUTER JOIN "AO_8542F1_IFJ_OBJ_ATTR_VAL" OAV ON OA."ID" = OAV."OBJECT_ATTRIBUTE_ID"
WHERE OTA."MAXIMUM_CARDINALITY" != -1
GROUP BY OTA."ID", OA."ID"
HAVING count(*) > OTA."MAXIMUM_CARDINALITY";