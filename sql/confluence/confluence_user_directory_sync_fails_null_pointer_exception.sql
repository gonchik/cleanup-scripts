/*
 User directory synchronization fails with NullPointerException at HibernateConfluenceUserDao.rename
 link:
 https://confluence.atlassian.com/confkb/user-directory-synchronization-fails-with-nullpointerexception-at-hibernateconfluenceuserdao-rename-794500074.html
 */

SELECT *
FROM user_mapping
WHERE
      LOWER(username) != lower_username
      OR lower_username IS NULL;
