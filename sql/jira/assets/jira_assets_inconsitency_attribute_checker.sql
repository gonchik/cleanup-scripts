/*
    This script checks for inconsistencies assets tables.
    Verify whether there is an inconsistency with the Objects attributes values in the database.
    Replace ? for one of the Object Ids affected.
    link:https://confluence.atlassian.com/jirakb/error-something-went-wrong-contact-administrator-exception-when-viewing-insight-objects-1178866909.html
 */

SELECT
    O.NAME OBJECT_NAME,
    O.OBJECT_TYPE_ID,
    OTA.NAME OTA_NAME,
    OA.ID OA_ID,
    OA.OBJECT_TYPE_ATTRIBUTE_ID,
    OA.OBJECT_ID,
    OAV.ID OAV_ID,
    OAV.BOOLEAN_VALUE,
    OAV.*
FROM AO_8542F1_IFJ_OBJ O
         LEFT OUTER JOIN AO_8542F1_IFJ_OBJ_ATTR OA ON O.ID = OA.OBJECT_ID
         LEFT OUTER JOIN AO_8542F1_IFJ_OBJ_TYPE_ATTR OTA ON OTA.ID = OA.OBJECT_TYPE_ATTRIBUTE_ID
         LEFT OUTER JOIN AO_8542F1_IFJ_OBJ_ATTR_VAL OAV ON OA.ID = OAV.OBJECT_ATTRIBUTE_ID
WHERE O.ID  = ?