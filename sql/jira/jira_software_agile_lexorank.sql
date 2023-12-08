/*
    * JIRA Software Agile Lexorank get field ID
    LexoRankIntegrityException: Expected exactly one rank row for issue x for rank field y, but found 2 rows
    link: https://confluence.atlassian.com/jirakb/lexorankintegrityexception-expected-exactly-one-rank-row-for-issue-x-for-rank-field-y-but-found-2-rows-1101933359.html
 */

-- get custom field ID
SELECT id
from CUSTOMFIELD
WHERE customfieldtypekey = 'com.pyxis.greenhopper.jira:gh-lexo-rank';

-- detect duplicate rank
SELECT "ISSUE_ID", count("ISSUE_ID")
FROM "AO_60DB71_LEXORANK"
WHERE "FIELD_ID" = 10009
GROUP BY "ISSUE_ID"
HAVING count("ISSUE_ID") > 1;


-- fix the duplicates
DELETE
from "AO_60DB71_LEXORANK"
WHERE "ID" in (WITH temp AS (SELECT "ID",
                                    "ISSUE_ID",
                                    ROW_NUMBER()
                                        OVER ( PARTITION BY "ISSUE_ID" ORDER BY "ISSUE_ID" )
                             from "AO_60DB71_LEXORANK"
                             WHERE "ISSUE_ID" in
                                   (SELECT "ISSUE_ID"
                                    from "AO_60DB71_LEXORANK"
                                    WHERE "FIELD_ID" = < rank_custom_field_ID >
                                    GROUP BY "ISSUE_ID"
                                    HAVING count("ISSUE_ID") > 1))
               select "ID"
               from temp
               where row_number = 1);