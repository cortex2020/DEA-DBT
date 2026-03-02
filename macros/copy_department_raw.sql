{% macro copy_department_raw() %}
  copy into {{ source('bronze', 'department_raw') }}
  (
    store_id,
    dept_id,
    dept_date,
    weekly_sales,
    isholiday,
    insert_dts,
    update_dts,
    source_file_name,
    source_file_row_number
  )
  from (
    select
      $1::int                  as store_id,
      $2::int                  as dept_id,
      $3::date                 as dept_date,
      $4::number               as weekly_sales,
      $5::boolean              as isholiday,
      current_timestamp()      as insert_dts,
      current_timestamp()      as update_dts,
      metadata$filename        as source_file_name,
      metadata$file_row_number as source_file_row_number
    from @DEA_WAL_DB.BRONZE.S3_WALMART_STAGE/department/
  )
  file_format = (format_name = DEA_WAL_DB.BRONZE.CSV_FORMAT)
  on_error = 'abort_statement'
  force = false
  ;
{% endmacro %}
