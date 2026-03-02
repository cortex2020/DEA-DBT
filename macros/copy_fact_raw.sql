{% macro copy_fact_raw() %}
  copy into {{ source('bronze', 'fact_raw') }}
  (
    store_id,
    fact_date,
    temperature,
    fuel_price,
    markdown1,
    markdown2,
    markdown3,
    markdown4,
    markdown5,
    cpi,
    unemployment,
    isholiday,
    insert_dts,
    update_dts,
    source_file_name,
    source_file_row_number
  )
  from (
    select
      $1::int                  as store_id,
      $2::date                 as fact_date,
      $3::number               as temperature,
      $4::number               as fuel_price,
      $5::number               as markdown1,
      $6::number               as markdown2,
      $7::number               as markdown3,
      $8::number               as markdown4,
      $9::number               as markdown5,
      $10::number              as cpi,
      $11::number              as unemployment,
      $12::boolean             as isholiday,
      current_timestamp()      as insert_dts,
      current_timestamp()      as update_dts,
      metadata$filename        as source_file_name,
      metadata$file_row_number as source_file_row_number
    from @DEA_WAL_DB.BRONZE.S3_WALMART_STAGE/fact/
  )
  file_format = (format_name = DEA_WAL_DB.BRONZE.CSV_FORMAT)
  on_error = 'abort_statement'
  force = false
  ;
{% endmacro %}
