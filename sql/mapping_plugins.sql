-- How generates the AO_ tables https://developer.atlassian.com/server/framework/atlassian-sdk/table-names/
-- KB of tables https://confluence.atlassian.com/jirakb/list-of-jira-server-ao-table-names-and-vendors-973498988.html
-- https://confluence.atlassian.com/jirakb/how-to-identify-active-objects-ao-tables-in-jira-application-database-830279481.html

-- DROP TABLE IF EXISTS PLUGIN_INFO_STORAGE;
CREATE TEMPORARY TABLE IF NOT EXISTS PLUGIN_INFO_STORAGE AS (
	SELECT *, upper(substring(md5(pluginkey), -6)) as pluginhash
	FROM pluginstate
 );

INSERT INTO PLUGIN_INFO_STORAGE (pluginkey, pluginenabled, pluginhash)
values ('com.tempoplugin.tempo-core', 'Tempo core map', '013613'),
		('com.intenso.jira.plugins.actions.jsd-actions', 'Deviniti apps', '34AB25'),
        ('com.atlassian.jira.plugins.jira-optimizer-plugin', 'Jira optimizers','0AC321'),
        ('com.atlassian.plugins.atlassian-whitelist-core-plugin', 'Atlassian Whitelist Core Plugin', '21D670'),
		('com.idalko.jira.plugins.igrid', 'iDalko Table Grid plugin', '272C37'),
        ('com.tempoplugin.tempo-plan-core','System Plugin: Tempo Planning API','2D3BEA'),
        ('com.radiantminds.roadmaps-jira','Portfolio for Jira','A415DF'),
        ('com.atlassian.whisper.atlassian-whisper-plugin', 'Atlassian Notifications', '21F425'),
        ('com.atlassian.jpo','Portfolio plans', 'D9132D'),
        ('com.tempoplugin.tempo-teams','Tempo Teams','AEFED0');


-- check tables
SELECT distinct	table_schema as database_name,
		table_name,
        substring(replace(table_name, 'AO_', ''),1, 6) as PLUGIN_KEY_HASH,
		PLUGIN_INFO_STORAGE.pluginkey,
        PLUGIN_INFO_STORAGE.pluginenabled
FROM information_schema.tables
left join PLUGIN_INFO_STORAGE on pluginhash like substring(replace(table_name, 'AO_', ''),1, 6)
WHERE table_type = 'BASE TABLE' and table_name like 'AO_%'
order by table_name, table_schema;
