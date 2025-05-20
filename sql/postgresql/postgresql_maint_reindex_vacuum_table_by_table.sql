-- https://support.atlassian.com/atlassian-knowledge-base/kb/optimize-and-improve-postgresql-performance-with-vacuum-analyze-and-reindex/
-- https://support.atlassian.com/jira/kb/jira-and-postgresql-server-consuming-high-cpu-after-users-login/

DO $$
DECLARE
    tbl RECORD;
    start_time TIMESTAMP;
    end_time TIMESTAMP;
BEGIN
    FOR tbl IN (
        SELECT schemaname, tablename 
        FROM pg_tables 
        WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
    ) 
    LOOP
        BEGIN
            RAISE NOTICE 'Processing: %.%', tbl.schemaname, tbl.tabelname;

            -- Step 1: Regular VACUUM first to minimize FULL needs
            EXECUTE format('VACUUM (VERBOSE) %I.%I', tbl.schemaname, tbl.tablename);

            -- Step 2: VACUUM FULL without parallel (exclusive lock)
            EXECUTE format('VACUUM (FULL, VERBOSE) %I.%I', tbl.schemaname, tbl.tablename);

            -- Step 3: REINDEX if needed (only for suspected corruption)
            EXECUTE format('REINDEX TABLE %I.%I', tbl.schemaname, tbl.tablename);

            -- Step 4: ANALYZE with statistics
            EXECUTE format('ANALYZE VERBOSE %I.%I', tbl.schemaname, tbl.tablename);

        EXCEPTION WHEN others THEN
            RAISE WARNING 'Failed on %.%: %', tbl.schemaname, tbl.tablename, SQLERRM;
        END;
    END LOOP;
END $$;
