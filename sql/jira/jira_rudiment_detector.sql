SELECT count(id) FROM entity_property WHERE ENTITY_NAME = 'fusion.caches.issue';
SELECT count(id) FROM entity_property WHERE ENTITY_NAME = 'hipchat.integration.caches.issue-mentions';



-- DETECT HOW MANY VALUES DO YOU HAVE IN Development panel
-- FYI: that info is like SQL cache
SELECT count(ID) FROM AO_575BF5_PROVIDER_ISSUE;
SELECT count(ID) FROM AO_575BF5_DEV_SUMMARY;

-- truncate AO_575BF5_DEV_SUMMARY;
-- truncate AO_575BF5_PROVIDER_ISSUE;

-- Investigate stucked values
FROM entity_property
WHERE json_value LIKE  '%9223371721494775807%';