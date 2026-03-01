{% macro copy_store_raw() %}

  {% set copy_sql %}

    copy into {{ source('bronze', 'STORE_RAW') }}
    (
      store_id,
      store_type,
      size,
      insert_dts,
      update_dts,
      source_file_name,
      source_file_row_number
    )
    from (
      select
        $1::int                  as store_id,
        $2::varchar              as store_type,
        $3::int                  as size,
        current_timestamp()      as insert_dts,
        current_timestamp()      as update_dts,
        metadata$filename        as source_file_name,
        metadata$file_row_number as source_file_row_number
      from @DEA_WAL_DB.BRONZE.S3_WALMART_STAGE/stores/
    )
    file_format = (format_name = DEA_WAL_DB.BRONZE.CSV_FORMAT)
    on_error = 'abort_statement'
    force = false
    ;

  {% endset %}

  {% do log(copy_sql, info=True) %}
  {% set res = run_query(copy_sql) %}
  {% do return(res) %}

{% endmacro %}
