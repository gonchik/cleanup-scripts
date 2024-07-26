/*
    Jira is unable to startup due to SQLServerException: String or binary data would be truncated

    2023-02-21 13:06:49,749+0100 main INFO      [c.a.jira.startup.DefaultJiraLauncher] Stopping launchers
    2023-02-21 13:06:49,757+0100 main ERROR      [o.a.c.c.C.[Catalina].[localhost].[/]] Exception sending context destroyed event to listener instance of class [com.atlassian.jira.startup.LauncherContextListener]
    java.lang.IllegalStateException: : interface com.atlassian.jira.cluster.ClusterManager
    ...
    Caused by: org.ofbiz.core.entity.GenericEntityException: while updating: [GenericEntity:ClusterNode][nodeState,ACTIVE][ip,xxxxxxxxxxxxxxxx.xxxxxx-xxxxxx-x.x.xxxx-xxxx-xxxx-xxxxx-xxxx-xxxxx.xxxxxxx][cacheListenerPort,40001][nodeVersion,9.4.1][nodeId,xxxxxxxx ][nodeBuildNumber,940001][timestamp,1676981063784] (SQL Exception while executing the following:UPDATE dbo.clusternode SET NODE_STATE=?, TIMESTAMP=?, IP=?, CACHE_LISTENER_PORT=?, NODE_BUILD_NUMBER=?, NODE_VERSION=? WHERE NODE_ID=? (String or binary data would be truncated.))
	    at org.ofbiz.core.entity.GenericDAO.singleUpdate(GenericDAO.java:364)
	    at org.ofbiz.core.entity.GenericDAO.customUpdate(GenericDAO.java:286)

    link: https://confluence.atlassian.com/jirakb/jira-is-unable-to-startup-due-to-sqlserverexception-string-or-binary-data-would-be-truncated-1216583585.html
 */
-- cause
-- This kind of issue happens when the hostname of the instance is more than 60 characters. The current DDL for clusternode is:
CREATE TABLE public.clusternode
(
    node_id             varchar(60) NOT NULL,
    node_state          varchar(60) NULL,
    "timestamp"         numeric(18) NULL,
    ip                  varchar(60) NULL,
    cache_listener_port numeric(18) NULL,
    node_build_number   numeric(18) NULL,
    node_version        varchar(60) NULL,
    CONSTRAINT pk_clusternode PRIMARY KEY (node_id)
);


-- solution
ALTER TABLE clusternode
ALTER
COLUMN node_id VARCHAR(120);