/*
 Exception - freetext-reindex java.lang.IllegalStateException: it.textValue must not be null
 https://confluence.atlassian.com/jirakb/exception-freetext-reindex-java-lang-illegalstateexception-it-textvalue-must-not-be-null-1096100429.html
 */

SELECT *
FROM "AO_8542F1_IFJ_OBJ_ATTR" OA,
     "AO_8542F1_IFJ_OBJ_ATTR_VAL" OAV
WHERE OAV."OBJECT_ATTRIBUTE_ID" = OA."ID"
  AND OAV."TEXT_VALUE" IS NULL
  AND OA."OBJECT_TYPE_ATTRIBUTE_ID" IN
      (SELECT "ID" FROM "AO_8542F1_IFJ_OBJ_TYPE_ATTR" OTA WHERE OTA."DEFAULT_TYPE_ID" IN (0, 9));


/*

 update "AO_8542F1_IFJ_OBJ_ATTR_VAL" OAV
 set "TEXT_VALUE" = 'XOXOXOXOX'
where OAV."ID" in (SELECT OAV."ID" FROM "AO_8542F1_IFJ_OBJ_ATTR" OA, "AO_8542F1_IFJ_OBJ_ATTR_VAL" OAV
WHERE OAV."OBJECT_ATTRIBUTE_ID" = OA."ID" AND OAV."TEXT_VALUE" IS NULL
AND OA."OBJECT_TYPE_ATTRIBUTE_ID" IN (SELECT "ID" FROM "AO_8542F1_IFJ_OBJ_TYPE_ATTR" OTA WHERE OTA."DEFAULT_TYPE_ID" IN (0,9)))

 */