-- retention policy for insight

SELECT count("ID")
FROM "AO_8542F1_IFJ_OBJ_HIST" hist
WHERE
"CREATED" < NOW() - INTERVAL '3 months' ;
-- and hist."OBJECT_TYPE_ATTRIBUTE_ID" = 400 ;

-- action for retention policy
/*
    DELETE
    FROM "AO_8542F1_IFJ_OBJ_HIST" hist
    WHERE
    "CREATED" < NOW() - INTERVAL '3 months'
    -- and hist."OBJECT_TYPE_ATTRIBUTE_ID" = 400 ;
*/