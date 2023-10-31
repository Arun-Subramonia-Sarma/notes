WITH tbl AS
(
    SELECT table_schema,
            TABLE_NAME
    FROM information_schema.tables
    WHERE TABLE_NAME not like 'pg_%'
        AND table_schema in ('keycloak','portal','public')
        AND TABLE_NAME not like ('aws%')
        AND TABLE_NAME NOT in ('lock_monitor','alembic_version','databasechangelog','databasechangeloglock','filter_values','seq_values','trailer_history_tmp','trailers_v2_tmp')
        AND TABLE_NAME not like '%partition%'
        AND TABLE_NAME not like '%default'
)
SELECT table_schema,
       TABLE_NAME,
       (xpath('/row/c/text()', query_to_xml(format('select count(*) as c from %I.%I', table_schema, TABLE_NAME), FALSE, TRUE, '')))[1]::text::int AS rows_n
FROM tbl
where tbl.TABLE_NAME not like '%partition%' and tbl.TABLE_NAME not like '%default'
ORDER BY table_schema,TABLE_NAME;
