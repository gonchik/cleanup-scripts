-- detect old hipchat history
SELECT count(id)
FROM entity_property
WHERE ENTITY_NAME = 'hipchat.integration.caches.issue-mentions';


/*

SELECT count(id)
FROM entity_property
WHERE ENTITY_NAME = 'hipchat.integration.caches.issue-mentions';

*/