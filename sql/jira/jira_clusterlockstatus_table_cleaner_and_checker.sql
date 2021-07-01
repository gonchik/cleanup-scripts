-- https://jira.atlassian.com/browse/JRASERVER-69113
--
select count(id) from clusterlockstatus;

select count(id) from clusterlockstatus where update_time < (EXTRACT(EPOCH FROM (NOW() - INTERVAL '3 days') ) * 1000);

-- delete from clusterlockstatus where update_time < (EXTRACT(EPOCH FROM TIMESTAMP '2021-05-30 00:00:00') * 1000);
