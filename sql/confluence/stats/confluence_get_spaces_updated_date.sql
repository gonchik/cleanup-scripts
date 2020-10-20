-- Get Status of Spaces with created and updated date for non Archived spaces

SELECT SPACEID,
	SPACEKEY as "KEY",
	SPACETYPE as "Type",
	CREATIONDATE as "Created",
	LASTMODDATE as "Updated"
FROM SPACES
WHERE SPACESTATUS != 'ARCHIVED'
ORDER BY LASTMODDATE ASC;