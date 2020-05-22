SELECT count(id) from entity_property where ENTITY_NAME = 'fusion.caches.issue';
SELECT count(id) from entity_property where ENTITY_NAME = 'hipchat.integration.caches.issue-mentions';



-- DETECT HOW MANY VALUES DO YOU HAVE IN Development panel
-- FYI: that info is like SQL cache
select count(ID) from AO_575BF5_PROVIDER_ISSUE;
select count(ID) from AO_575BF5_DEV_SUMMARY;

-- truncate AO_575BF5_DEV_SUMMARY;
-- truncate AO_575BF5_PROVIDER_ISSUE;
