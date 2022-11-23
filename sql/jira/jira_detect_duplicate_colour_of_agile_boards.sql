-- @todo rewrite for T-SQL (MSSQL)
-- works well on MySQL, PostgreSQL
-- detect duplicate card colours


-- MySQL
/*
    SELECT *
    FROM AO_60DB71_CARDCOLOR
    WHERE ID in
        (SELECT ID FROM
            ( SELECT t.ID,t.RAPID_VIEW_ID, count(val)
			    FROM AO_60DB71_CARDCOLOR t
			    GROUP BY t.RAPID_VIEW_ID, val
			    HAVING count(val) > 1 ) dup);
 */


SELECT *
FROM "AO_60DB71_CARDCOLOR"
WHERE ID in
    (SELECT ID FROM
        ( SELECT t.ID,t."RAPID_VIEW_ID", count(val)
			FROM "AO_60DB71_CARDCOLOR" t
			GROUP BY t."RAPID_VIEW_ID", val
			HAVING count(val) > 1 ) dup);


-- delete duplicates
-- PostgreSQL
/*
 DELETE
 FROM "AO_60DB71_CARDCOLOR"
 WHERE ID in
    (SELECT ID FROM
        ( SELECT t.ID,t."RAPID_VIEW_ID", count(val)
			FROM "AO_60DB71_CARDCOLOR" t
			GROUP BY t."RAPID_VIEW_ID", val
			HAVING count(val) > 1 ) dup);
 */


-- MySQL
/*

SET SQL_SAFE_UPDATES=0;
DELETE FROM AO_60DB71_CARDCOLOR
WHERE ID in
    (SELECT ID FROM
        (SELECT t.ID, count(val)
        FROM AO_60DB71_CARDCOLOR t
        GROUP BY RAPID_VIEW_ID, val HAVING count(val)>1) dup);

*/
