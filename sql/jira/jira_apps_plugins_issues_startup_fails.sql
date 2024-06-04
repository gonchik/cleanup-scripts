/*
    Jira startup fails with message that required plugins are not started
    url: https://confluence.atlassian.com/jirakb/jira-startup-fails-with-message-that-required-plugins-are-not-started-254738702.html
 */

SELECT * FROM pluginstate where pluginenabled = 'false';


DELETE FROM pluginstate WHERE pluginkey='<pluginkey from query above>';


DELETE FROM pluginstate WHERE pluginkey LIKE 'com.atlassian.%';
