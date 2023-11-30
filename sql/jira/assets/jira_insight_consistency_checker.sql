/*
    Insight Consistency checker
    Check orphaned objects
 */

SELECT count("ID")
FROM "AO_8542F1_IFJ_OBJ_HIST"
WHERE "OBJECT_ID" is null;

SELECT count("ID")
FROM "AO_8542F1_IFJ_OBJ_JIRAISSUE"
WHERE "OBJECT_ID" is null;

SELECT count("ID")
FROM "AO_8542F1_IFJ_COMMENT"
WHERE "OBJECT_ID" is null;

SELECT count("ID")
FROM "AO_8542F1_IFJ_OBJ_ATTACH"
WHERE "OBJECT_ID" is null;

SELECT count("ID")
FROM "AO_8542F1_IFJ_OBJ_WATCH"
WHERE "OBJECT_ID" is null;

-- detect attributes without linkage to object
SELECT count("ID")
FROM "AO_8542F1_IFJ_OBJ_ATTR_VAL"
WHERE "OBJECT_ATTRIBUTE_ID" is null;