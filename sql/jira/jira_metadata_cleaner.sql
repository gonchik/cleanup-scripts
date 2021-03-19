/*
    Detect old HipChat metadata and development metadata
 */

SELECT count(id) from entity_property where ENTITY_NAME = 'fusion.caches.issue';
SELECT count(id) from entity_property where ENTITY_NAME = 'hipchat.integration.caches.issue-mentions';
SELECT * from entity_property where ENTITY_NAME = 'fusion.caches.issue';



/*
    Clean old HipChat metadata and development metadata
*/

SET SQL_SAFE_UPDATES=0;
DELETE from entity_property where json_value like '%9223371721494775807%';
DELETE from entity_property where PROPERTY_KEY like 'jpo-exclude-from-plan';
DELETE from entity_property where PROPERTY_KEY like 'jpo-issue-properties';
DELETE from entity_property where PROPERTY_KEY like 'hipchat.issue.dedicated.room';
DELETE from entity_property where ENTITY_NAME = 'hipchat.integration.caches.issue-mentions';