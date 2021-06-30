/*
    Monthly created attachments
*/

SELECT
    DATE_FORMAT(created, '%Y-%m'), COUNT(*)
FROM
    fileattachment
GROUP BY YEAR(created) , MONTH(created)
limit 100;