-- Jira server throws NullPointerException when creating new issues or changing project settings
-- https://confluence.atlassian.com/jirakb/jira-server-throws-nullpointerexception-when-creating-new-issues-or-changing-project-settings-292651342.html

SELECT * FROM fieldconfiguration WHERE id IN (SELECT id FROM fieldconfigscheme WHERE configname='Default Issue Type Scheme') AND fieldid = 'issuetype';

SELECT * FROM configurationcontext WHERE customfield = 'issuetype' AND project IS NULL AND fieldconfigscheme = (SELECT id FROM fieldconfigscheme WHERE configname='Default Issue Type Scheme');

SELECT * FROM fieldconfigschemeissuetype WHERE id = 10100 OR fieldconfigscheme IN (SELECT id FROM fieldconfiguration WHERE id IN (SELECT id FROM fieldconfigscheme where configname='Default Issue Type Scheme'));