/*
    Project Shortcut is not showing in some projects
    link: https://confluence.atlassian.com/jirakb/project-shortcut-is-not-showing-in-some-projects-975017597.html
 */


select * from "AO_550953_SHORTCUT" s, project p where s."PROJECT_ID" = p.id and s."SHORTCUT_TYPE" = 'project.shortcut.default.link';

-- resolution

delete  from "AO_550953_SHORTCUT" where "SHORTCUT_TYPE" = 'project.shortcut.default.link';
