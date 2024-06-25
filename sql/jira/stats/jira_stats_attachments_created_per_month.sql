/*
    Monthly created attachments, and yearly.

*/

SELECT to_char(created, 'YYYY-MM') AS "Year",
       COUNT(*)                    AS "Number of Attachments"
FROM fileattachment
GROUP BY to_char(created, 'YYYY-MM')
ORDER BY 1 LIMIT 100;

SELECT to_char(created, 'YYYY') AS "Year",
       COUNT(*)                    AS "Number of Attachments"
FROM fileattachment
GROUP BY to_char(created, 'YYYY')
ORDER BY 1 LIMIT 100;


-- mysql query for monthly
SELECT DATE_FORMAT(created, '%Y-%m') as "Months",
       COUNT(*)                      as "Number of Attachments"
FROM fileattachment
GROUP BY YEAR (created), MONTH (created)
ORDER BY 1
    LIMIT 100;

-- mysql query for yearly
SELECT DATE_FORMAT(created, '%Y') as "Months",
       COUNT(*)                      as "Number of Attachments"
FROM fileattachment
GROUP BY YEAR (created), MONTH (created)
ORDER BY 1
    LIMIT 100;
