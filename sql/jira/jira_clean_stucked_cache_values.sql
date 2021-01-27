SELECT count(id) FROM entity_property WHERE ENTITY_NAME = 'fusion.caches.issue';


-- Investigate stucked values of caches
SELECT count(*) FROM entity_property
WHERE json_value LIKE  '%9223371721494775807%';

-- DELETE FROM entity_property WHERE json_value LIKE  '%9223371721494775807%';