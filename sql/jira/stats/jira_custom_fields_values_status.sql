-- it's heavy requests

-- it's just helps to understand the situation with one of the EAV table model
SELECT count(id)
FROM customfieldvalue;

-- it's just yet another small calculator it's better to use from the
SELECT
	   customfield.id, customfield.cfname, count(*)
FROM customfield
    LEFT JOIN customfieldvalue  on customfield.id = customfieldvalue.customfield
GROUP BY customfield.id
ORDER BY count(*) DESC
;
