/*
	Monthly created active users as Jira Core or Jira Software application access user
*/
SELECT date_format(u.created_date, '%Y-%m') as "Period", count(*) as "Created tickets"
FROM cwd_user u
JOIN cwd_membership m ON u.id = m.child_id AND u.directory_id = m.directory_id
JOIN licenserolesgroup lrg ON lower(m.parent_name) = lower(lrg.group_id)
JOIN cwd_directory d ON m.directory_id = d.id WHERE d.active = '1' AND u.active = '1' AND license_role_name in ('jira-software', 'jira-core')
GROUP BY year(u.created_date), month(u.created_date) ;
