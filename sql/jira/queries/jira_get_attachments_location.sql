/*
    Locate Jira server / Data center file attachments in the filesystem
    Jira stores attachments, such as files and images, in a file system.
    This page explains where attachments are located within this file system.
    link: https://confluence.atlassian.com/jirakb/locate-jira-server-file-attachments-in-the-filesystem-859487788.html
 */
SELECT fa.id,
       fa.filename,
       pkk.pkey                                                                                    as project,
       ji.issuenum,
       concat('/var/atlassian/application-data/jira', '/data/attachments/', pkk.pkey, '/',
              CEILING((ji.issuenum / 10000)) * 10000, '/', pkk.pkey, '-', ji.issuenum, '/', fa.id) as Path,
       case
           when fa.mimetype = 'image/png' OR fa.mimetype = 'image/gif' OR fa.mimetype = 'image/jpeg' then concat(
                   '/var/atlassian/application-data/jira', '/data/attachments/', pkk.pkey, '/',
                   CEILING((ji.issuenum / 10000)) * 10000, '/', pkk.pkey, '-', ji.issuenum, '/thumbs/_thumb_', fa.id,
                   '.png') end                                                                     as thumbnail
FROM fileattachment fa
         join jiraissue ji on ji.id = fa.issueid
         join (SELECT DISTINCT
               ON (project_id) project_key as pkey, project_id
               FROM project_key
               ORDER BY project_id, project_key desc) pkk
              on ji.project = pkk.project_id
WHERE fa.created > '2021-04-20 13:45';