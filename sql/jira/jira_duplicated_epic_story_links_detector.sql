-- duplicate epic-story link
-- https://confluence.atlassian.com/jirakb/duplicate-epic-story-link-types-in-issuelinktype-table-causing-errors-in-search-using-has-epic-779158623.html
-- if you see more that 1, something wrong

select * from issuelinktype where linkname = 'Epic-Story Link';