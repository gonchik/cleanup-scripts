/*
    Insight Consistency checker
    Check orphaned objects
 */

select *
from "AO_8542F1_IFJ_OBJ_HIST"
where "OBJECT_ID" is null;

select *
from "AO_8542F1_IFJ_OBJ_JIRAISSUE"
where "OBJECT_ID" is null;

select *
from "AO_8542F1_IFJ_COMMENT"
where "OBJECT_ID" is null;

select *
from "AO_8542F1_IFJ_OBJ_ATTACH"
where "OBJECT_ID" is null;

select *
from "AO_8542F1_IFJ_OBJ_WATCH"
where "OBJECT_ID" is null;

select *
from "AO_8542F1_IFJ_OBJ_ATTR_VAL"
where "REFERENCED_OBJECT_ID" is null;