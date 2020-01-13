/* Prepare list of not active projects */
SET @latestActivityDate='2019-01-01 00:00:00';

SELECT
    pc.cname AS 'Project Category',
    p.id AS 'Project ID',
    p.pkey AS 'Project Key',
    p.pname AS 'Project Name',
    MAX(i.updated) AS 'Latest activity',
    COUNT(*) AS 'Issue count'
FROM
    jiraissue AS i
join project AS p on i.project = p.id
join nodeassociation AS na on p.id=na.SOURCE_NODE_ID
join projectcategory AS pc on pc.ID=na.SINK_NODE_ID and na.ASSOCIATION_TYPE = 'ProjectCategory'
where pc.cname not in ('Archive', 'DEPRECATED')
GROUP BY p.id
HAVING MAX(i.updated) < @latestActivityDate
ORDER BY MAX(i.updated);
