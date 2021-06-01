-- https://jira.atlassian.com/browse/JRASERVER-69113
--
select count(it) from clusterlockstatus;
-- delete from clusterlockstatus where update_time < (EXTRACT(EPOCH FROM TIMESTAMP '2021-05-30 00:00:00') * 1000);
