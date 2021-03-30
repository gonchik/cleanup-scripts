-- Boards Are Not Visible After the Filter is Deleted
-- https://confluence.atlassian.com/jirakb/boards-are-not-visible-after-the-filter-is-deleted-779158656.html
-- you can do it on instance and then clean cache

SELECT *
FROM "AO_60DB71_RAPIDVIEW"
WHERE "SAVED_FILTER_ID" NOT IN (SELECT id FROM searchrequest);