-- Duplicate key value errors in logs in Jira Server using PostgreSQL
-- https://confluence.atlassian.com/jirakb/duplicate-key-value-errors-in-logs-in-jira-server-using-postgresql-958771364.html
select max("ID") from "AO_60DB71_SWIMLANE";
select * from "AO_60DB71_SWIMLANE_ID_seq";
