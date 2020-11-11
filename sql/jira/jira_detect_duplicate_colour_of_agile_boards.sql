-- detect duplicate card colours
SELECT *
FROM AO_60DB71_CARDCOLOR
WHERE ID in
    (SELECT ID FROM
        (SELECT t.*, count(val) as c
        FROM AO_60DB71_CARDCOLOR t
        GROUP BY RAPID_VIEW_ID, val HAVING c>1) dup);

-- delete duplicates
/*

DELETE FROM AO_60DB71_CARDCOLOR
WHERE ID in
    (SELECT ID FROM
        (SELECT t.*, count(val) as c
        FROM AO_60DB71_CARDCOLOR t
        GROUP BY RAPID_VIEW_ID, val HAVING c>1) dup);

*/