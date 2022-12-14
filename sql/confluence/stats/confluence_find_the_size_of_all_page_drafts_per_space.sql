/*
    How to query the database to find the size of all page drafts per space
    Confluence administrators may want to audit draft page usage on their instance.
    link: https://confluence.atlassian.com/confkb/how-to-query-the-database-to-find-the-size-of-all-page-drafts-per-space-998664642.html
*/
select
    count(content.contentid) as number_of_drafts,
    pg_size_pretty(sum(pg_column_size(bodycontent.body))) as total_size_of_drafts,
	spaces.spacename as space_name
from bodycontent
inner join content on (content.contentid = bodycontent.contentid)
inner join spaces on (content.spaceid = spaces.spaceid)
where bodycontent.contentid in
(select contentid from CONTENT where CONTENT_STATUS = 'draft' and CONTENTTYPE = 'PAGE')
GROUP BY space_name
ORDER BY number_of_drafts DESC, space_name;