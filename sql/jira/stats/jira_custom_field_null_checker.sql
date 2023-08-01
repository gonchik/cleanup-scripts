-- https://confluence.atlassian.com/jirakb/searching-for-jira-issue-by-custom-field-value-results-in-nullpointerexception-223224206.html

SELECT c.cfname      AS "Custom Field",
       o.customvalue AS "Value"
FROM customfield c
         JOIN customfieldoption o ON c.id = o.customfield
WHERE customvalue IS NULL;


-- DELETE FROM customfieldoption WHERE customvalue is null;


SELECT customfield
FROM customfieldoption
WHERE customfield NOT IN (SELECT id
                          FROM customfield);


/*
 DELETE
 FROM
	customfieldoption
 WHERE
	customfield NOT IN (
		SELECT
			id
		FROM
			customfield
		);
 */