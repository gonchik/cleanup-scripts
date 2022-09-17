/*
 User directory fails to sync with Confluence due to 'Unable to find user mapping' error
 Link: https://confluence.atlassian.com/confkb/user-directory-fails-to-sync-with-confluence-due-to-unable-to-find-user-mapping-error-894116978.html
 */

SELECT * FROM cwd_user WHERE lower_user_name NOT IN (SELECT lower_username FROM user_mapping);
