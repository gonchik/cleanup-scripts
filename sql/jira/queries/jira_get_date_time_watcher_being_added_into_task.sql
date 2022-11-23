-- To identify when a watcher was added to an issue via database query
-- https://confluence.atlassian.com/jirakb/identify-date-time-of-a-watcher-being-added-to-an-issue-836077733.html
SELECT
    concat(project.pkey,'-',jiraissue.issuenum) AS pkey_issuenum, cwd_user.user_name, userassociation.created
FROM
    userassociation
        JOIN
    cwd_user
    ON
            userassociation.source_name = cwd_user.user_name
        JOIN
    jiraissue
    ON
            jiraissue.ID = userassociation.SINK_NODE_ID
        JOIN
    project
    ON
            project.id = jiraissue.PROJECT
WHERE
        jiraissue.id = userassociation.sink_node_id AND userassociation.association_type='WatchIssue' AND userassociation.sink_node_entity ='Issue'
ORDER BY cwd_user.user_name ASC;
