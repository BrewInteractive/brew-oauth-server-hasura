DO
$$
DECLARE
    table_name text;
BEGIN
    FOR table_name IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE format('SELECT audit.audit_table(''%I.%I'')', 'public', table_name);
    END LOOP;
END;
$$;
