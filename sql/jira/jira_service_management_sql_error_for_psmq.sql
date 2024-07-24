/*
    SQLServerException: The ntext data type cannot be selected as DISTINCT because it is not comparable
    link: https://confluence.atlassian.com/jirakb/sqlserverexception-the-ntext-data-type-cannot-be-selected-as-distinct-because-it-is-not-comparable-1141987390.html
    2022-02-22 18:03:57,449-0500 localhost-startStop-1 ERROR anonymous     [c.a.s.core.lifecycle.DefaultLifecycleManager]
    LifecycleAware.onStart() failed for component with class 'com.atlassian.servicedesk.plugins.base.internal.bootstrap.lifecycle.InternalBasePluginLauncher'
    from plugin 'com.atlassian.servicedesk.internal-base-plugin'
 */


SELECT s.name, t.name, i.name, c.name
FROM sys.tables t
         INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         INNER JOIN sys.indexes i on i.object_id = t.object_id
         INNER JOIN sys.index_columns ic on ic.object_id = t.object_id
         INNER JOIN sys.columns c on c.object_id = t.object_id and
                                     ic.column_id = c.column_id
WHERE t.name = 'AO_319474_MESSAGE';

exec sp_columns AO_319474_MESSAGE;


-- fix and double check it
ALTER TABLE dbo.AO_319474_MESSAGE ALTER COLUMN MSG_DATA NVARCHAR(MAX) NULL;
