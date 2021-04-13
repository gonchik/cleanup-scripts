/*
    Passed List Had More than One Value when Calling Dashboard
    java.lang.IllegalArgumentException: Passed List had more than one value.

*/
-- https://confluence.atlassian.com/jirakb/passed-list-had-more-than-one-value-when-calling-dashboard-215486151.html

-- Diagnosis
select username, pagename, count(pagename)
from portalpage
group by username,pagename
having count(pagename) > 1;



-- Resolution
-- method 1
select username,id
from portalpage
where username in (select username
                    from portalpage
                    group by username,pagename
                    having count(pagename) > 1)
-- Delete all the rows except one row for each of those users using the ID of the row.


-- method 2
-- Run the below SQL for a direct deletion of all the duplicated rows. This has been tested only on PostgreSQL:
DELETE
FROM portalpage p1 USING
  (SELECT username,
          id
   FROM portalpage
   WHERE username IN
       (SELECT username
        FROM portalpage
        GROUP BY username,
                 pagename HAVING count(pagename) > 1)) p2,
  (SELECT username,
          max(id) maxid
   FROM portalpage
   WHERE username IN
       (SELECT username
        FROM portalpage
        GROUP BY username,
                 pagename HAVING count(pagename) > 1)
   GROUP BY username) p3
WHERE p1.username = p2.username
  AND p3.maxid != p1.id
  AND p3.username = p2.username;