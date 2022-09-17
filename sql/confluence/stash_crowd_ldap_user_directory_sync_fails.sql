/*
 Unable to sync crowd user directory - query did not return a unique result
 Scenario 2: duplicate row in cwd_user
 link: https://confluence.atlassian.com/stashkb/unable-to-sync-crowd-user-directory-query-did-not-return-a-unique-result-664993976.html
 */

SELECT *
FROM cwd_user
WHERE external_id in
      (SELECT external_id
       FROM cwd_user
       GROUP BY external_id
       HAVING COUNT(*) > 1);