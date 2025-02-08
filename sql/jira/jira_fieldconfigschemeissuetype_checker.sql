-- Jira server throws communication error when filtering or searching issues
-- Check via next query
-- https://confluence.atlassian.com/jirakb/jira-server-throws-communication-error-when-filtering-or-searching-issues-591593887.html
select fc.id
from fieldconfiguration fc
         left join fieldconfigschemeissuetype fcsit on (fc.id = fcsit.fieldconfiguration)
where fcsit.id is null;