select
  store_id,
  dept_id,
  store_weekly_sales,
  fuel_price,
  store_temperature,
  unemployment,
  cpi,
  markdown1,
  markdown2,
  markdown3,
  markdown4,
  markdown5,
  dbt_valid_from  as insert_date,
  dbt_updated_at  as update_date,
  dbt_valid_from  as vrsn_start_date,
  dbt_valid_to    as vrsn_end_date
from {{ ref('walmart_fact_snapshot') }}
