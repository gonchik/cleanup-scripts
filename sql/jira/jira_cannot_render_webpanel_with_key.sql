/*
    JIRA Cannot render WebPanel with key 'com.atlassian.jira.jira-projects-plugin:summary-page-project-key' when Browsing Project
    link: https://confluence.atlassian.com/jirakb/jira-cannot-render-webpanel-with-key-com-atlassian-jira-jira-projects-plugin-summary-page-project-key-when-browsing-project-759858703.html

 */


SELECT * FROM projectcategory where description is null;

-- fix
UPDATE projectcategory set description = '' where description is null;
