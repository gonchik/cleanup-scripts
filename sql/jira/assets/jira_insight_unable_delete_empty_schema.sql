/*
 Unable to delete empty Insight object scheme, Something went wrong, contact administrator
 https://confluence.atlassian.com/jirakb/unable-to-delete-empty-insight-object-scheme-something-went-wrong-contact-adminstrator-1124181236.html

 Detect orphaned elements
 */

SELECT *
FROM "AO_8542F1_IFJ_OBJ"
WHERE "ID" IS NULL;

SELECT *
FROM "AO_8542F1_IFJ_OBJ_ATTR"
WHERE "OBJECT_ID" IS NULL;

SELECT *
FROM "AO_8542F1_IFJ_OBJ_ATTR_VAL"
WHERE "OBJECT_ATTRIBUTE_ID" IS NULL;

SELECT *
FROM "AO_8542F1_IFJ_OBJ_HIST"
WHERE "OBJECT_ID" is NULL;

-- remove data from schema
SELECT *
FROM "AO_8542F1_IFJ_OBJ"
WHERE "OBJECT_TYPE_ID" IN (SELECT "ID" FROM "AO_8542F1_IFJ_OBJ_TYPE" WHERE "OBJECT_SCHEMA_ID" = '9');

