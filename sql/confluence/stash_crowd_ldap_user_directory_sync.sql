/*
 Unable to sync crowd user directory - query did not return a unique result
 link: https://confluence.atlassian.com/stashkb/unable-to-sync-crowd-user-directory-query-did-not-return-a-unique-result-664993976.html
 */

SELECT *
FROM cwd_membership
WHERE directory_id in
      (SELECT directory_id
       FROM cwd_membership
       GROUP BY directory_id, lower_parent_name, lower_child_name, membership_type
       HAVING COUNT(*) > 1)
  AND lower_parent_name in
      (SELECT lower_parent_name
       FROM cwd_membership
       GROUP BY directory_id, lower_parent_name, lower_child_name, membership_type
       HAVING COUNT(*) > 1)
  AND lower_child_name in
      (SELECT lower_child_name
       FROM cwd_membership
       GROUP BY directory_id, lower_parent_name, lower_child_name, membership_type
       HAVING COUNT(*) > 1)
  AND membership_type in
      (SELECT membership_type
       FROM cwd_membership
       GROUP BY directory_id, lower_parent_name, lower_child_name, membership_type
       HAVING COUNT(*) > 1);