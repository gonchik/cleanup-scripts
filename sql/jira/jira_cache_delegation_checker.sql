-- Cache Delegation: null keys are not permitted
-- https://confluence.atlassian.com/jirakb/cache-delegation-null-keys-are-not-permitted-952050953.html

select * from issuetypescreenschemeentity where fieldscreenscheme is null;
select * from issuetypescreenschemeentity where fieldscreenscheme not in (select id from fieldscreenscheme);

-- delete rows and clean Jira cache