/*
    Stats query to easy meet with requirements of Insight app

*/

-- count of objects
select count("ID")
FROM "AO_8542F1_IFJ_OBJ";


-- count of attributes
select count("ID")
FROM "AO_8542F1_IFJ_OBJ_ATTR";


-- count of attibute values usually the same as previous one
select count("ID")
FROM "AO_8542F1_IFJ_OBJ_ATTR_VAL"  ;

-- count of history records
select count("ID")
FROM "AO_8542F1_IFJ_OBJ_HIST"  ;


-- count of releated between Jira ticket and objects
select count("ID")
FROM "AO_8542F1_IFJ_OBJ_JIRAISSUE" ;