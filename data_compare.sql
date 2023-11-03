WITH tbl AS
(
    SELECT table_schema,
            TABLE_NAME
    FROM information_schema.tables
    WHERE TABLE_NAME not like 'pg_%'
        AND table_schema in ('keycloak','public')
        AND TABLE_NAME not like ('aws%')
        AND TABLE_NAME NOT in ('lock_monitor',
									'alembic_version',
									'databasechangelog',
									'databasechangeloglock',
									'filter_values',
									'pg_buffercache',
									'trailer_history_copy_failure',
									'trailer_history_tmp',
									'trailer_live_replication_failure',
									'trailer_status_intermediate_log',
									'trailer_status_intermediate_logs_failure',
									'trailer_status_live_replication_failure',
									'trailers_copy_failure',
									'trailers_intermediate_logs',
									'trailers_intermediate_logs_failure',
									'trailer_status_live_replication_failure',
									'trailers_v2_tmp',
									'map_updates',
									'site_map_regions',
									'site_maps',
									'site_map_info',
									'user_site_preferences',
									'foo'
								)
        AND TABLE_NAME not like '%partition%'
        AND TABLE_NAME not like '%default'
)
SELECT table_schema,
       TABLE_NAME,
       (xpath('/row/c/text()', query_to_xml(format('select count(*) as c from %I.%I', table_schema, TABLE_NAME), FALSE, TRUE, '')))[1]::text::int AS rows_n
FROM tbl
where tbl.TABLE_NAME not like '%partition%' and tbl.TABLE_NAME not like '%default'
ORDER BY table_schema,TABLE_NAME;

