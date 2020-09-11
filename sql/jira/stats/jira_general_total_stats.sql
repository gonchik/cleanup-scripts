--total number of users
SELECT COUNT(ID) FROM cwd_user;

--total number of groups
SELECT COUNT(ID) FROM cwd_group;

--total number of attachments
SELECT COUNT(ID) FROM fileattachment;

--total number of issues
SELECT COUNT(ID) FROM jiraissue;

--total number of projects
SELECT COUNT(ID) FROM project;

--total number of comments
SELECT COUNT(ID) FROM jiraaction;

--total number of custom fields
SELECT COUNT(ID) FROM customfield;

--total number of issue security schemes
SELECT COUNT(ID) FROM issuesecurityscheme;

--total number of screen schemes
SELECT COUNT(ID) FROM fieldscreenscheme;

--total number of components
SELECT COUNT(ID) FROM component;

--total number of issue types
SELECT COUNT(ID) FROM issuetype;

--total number of priorities
SELECT COUNT(ID) FROM priority;

--total number of resolution
SELECT COUNT(ID) FROM resolution;

--total number of screens
SELECT COUNT(ID) FROM fieldscreen;

--total number of statuses
SELECT COUNT(ID) FROM issuestatus;

--total number of versions
SELECT COUNT(ID) FROM projectversion;