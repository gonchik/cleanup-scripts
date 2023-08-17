/*
 When deleting an Insight Schema or searching for objects, Insight leads to an error: Something went wrong. Contact administrator
 https://confluence.atlassian.com/jirakb/when-deleting-an-insight-schema-or-searching-for-objects-insight-leads-to-an-error-something-went-wrong-contact-administrator-1096089797.html
 */

SELECT OAV."TEXT_VALUE",
       O."NAME",
       O."OBJECT_TYPE_ID",
       OTA."NAME",
       OA."ID",
       OA."OBJECT_TYPE_ATTRIBUTE_ID",
       OA."OBJECT_ID",
       OAV."ID",
       OAV."OBJECT_ATTRIBUTE_ID"
FROM "AO_8542F1_IFJ_OBJ" O
         LEFT OUTER JOIN "AO_8542F1_IFJ_OBJ_ATTR" OA ON O."ID" = OA."OBJECT_ID"
         LEFT OUTER JOIN "AO_8542F1_IFJ_OBJ_TYPE_ATTR" OTA ON OTA."ID" = OA."OBJECT_TYPE_ATTRIBUTE_ID"
         LEFT OUTER JOIN "AO_8542F1_IFJ_OBJ_ATTR_VAL" OAV ON OA."ID" = OAV."OBJECT_ATTRIBUTE_ID"
WHERE O."ID" = ?;

