-- NullPointerException while linking issues
-- https://confluence.atlassian.com/jirakb/nullpointerexception-while-linking-issues-313463281.html
select * from issuelinktype where inward is null or outward is null;

