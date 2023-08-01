-- That query helps to understand the default value of custom field
-- do cleanup after that
SELECT customfield.cfname, concat('customfield_', customfield.ID)
FROM fieldconfigscheme
         INNER JOIN genericconfiguration on genericconfiguration.DATAKEY = fieldconfigscheme.ID
         JOIN customfield on concat('customfield_', customfield.ID) = fieldconfigscheme.FIELDID;