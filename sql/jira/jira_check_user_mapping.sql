-- check consistency of mapping membership and group
SELECT lower_parent_name
FROM cwd_membership
WHERE parent_id not in (SELECT ID from cwd_group);