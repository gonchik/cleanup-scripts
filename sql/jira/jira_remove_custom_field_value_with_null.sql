-- https://confluence.atlassian.com/jirakb/nullpointerexception-when-deleting-a-custom-field-218272042.html

-- Let's detect custom field value without issue value

SELECT * FROM customfieldvalue where issue is null;
-- DELETE from customfieldvalue where issue is null;

-- detect empty rows
SELECT *
FROM customfieldvalue
WHERE  stringvalue is null
AND numbervalue is null
AND textvalue is null
AND datevalue is null
limit 10;