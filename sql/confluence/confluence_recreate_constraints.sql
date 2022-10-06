/*
 How to drop and recreate the database constraints on PostgreSQL.
 link: https://confluence.atlassian.com/kb/how-to-drop-and-recreate-the-database-constraints-on-postgresql-776812450.html
 */

-- CREATING A FILE TO DROP THE CONSTRAINTS.
copy (SELECT 'ALTER TABLE '||nspname||'.\"'||relname||'\" DROP CONSTRAINT \"'||conname||'\";'
      FROM pg_constraint
               INNER JOIN pg_class ON conrelid=pg_class.oid
               INNER JOIN pg_namespace ON pg_namespace.oid=pg_class.relnamespace
      ORDER BY CASE WHEN contype='f' THEN 0 ELSE 1 END,contype,nspname,relname,conname) to '<path-to-save>/droppingConstraints.sql';


-- CREATING A FILE TO ADD THE CONSTRAINTS LATER ON.
copy (SELECT 'ALTER TABLE '||nspname||'.\"'||relname||'\" ADD CONSTRAINT \"'||conname||'\" '|| pg_get_constraintdef(pg_constraint.oid)||';'
      FROM pg_constraint
               INNER JOIN pg_class ON conrelid=pg_class.oid
               INNER JOIN pg_namespace ON pg_namespace.oid=pg_class.relnamespace
      ORDER BY CASE WHEN contype='f' THEN 0 ELSE 1 END DESC,contype DESC,nspname DESC,relname DESC,conname DESC) to '<path-to-save>/addingConstraint.sql';