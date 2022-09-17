/*
 Synchronization with external directory fails with error: query did not return unique result due to duplicate groups
 Link:
 https://confluence.atlassian.com/confkb/synchronization-with-external-directory-fails-with-error-query-did-not-return-unique-result-due-to-duplicate-groups-838543854.html
 */

SELECT lower_group_name
FROM cwd_group
GROUP BY lower_group_name
HAVING (COUNT(lower_group_name) > 1);
