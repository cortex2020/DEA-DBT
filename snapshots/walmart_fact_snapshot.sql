{% snapshot walmart_fact_snapshot %}

{{
  config(
    strategy='check',
    unique_key="store_id || '-' || dept_id || '-' || to_varchar(fact_date)",
    check_cols=[
      'store_weekly_sales',
      'fuel_price',
      'store_temperature',
      'unemployment',
      'cpi',
      'markdown1','markdown2','markdown3','markdown4','markdown5'
    ],
    pre_hook=["{{ copy_fact_raw() }}", "{{ copy_department_raw() }}"],
  )
}}

select
  f.store_id,
  d.dept_id,
  f.fact_date,
  d.weekly_sales as store_weekly_sales,
  f.fuel_price,
  f.temperature as store_temperature,
  f.unemployment,
  f.cpi,
  f.markdown1,
  f.markdown2,
  f.markdown3,
  f.markdown4,
  f.markdown5
from {{ source('bronze','FACT_RAW') }} f
join {{ source('bronze','DEPARTMENT_RAW') }} d
  on d.store_id = f.store_id
 and d.dept_date = f.fact_date

{% endsnapshot %}
