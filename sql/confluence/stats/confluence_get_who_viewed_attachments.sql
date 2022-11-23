-- Ability to see which users viewed the attachments in Confluence Analytics
-- https://jira.atlassian.com/browse/CONFSERVER-69474

select c.title,to_timestamp(cast ("EVENT_AT" as bigint)/ 1000) ,
       "NAME", "SPACE_KEY", um.username
from "AO_7B47A5_EVENT" e, content c, user_mapping um
where
    e."USER_KEY" = um.user_key  and
    e."CONTENT_ID" = c.contentid and
    e."NAME" = 'attachment_viewed';
