{% snapshot walmart_fact_snapshot %}

{{
  config(
    strategy='check',
    unique_key="store_id || '-' || dept_id || '-' || date_id",
    check_cols=[
      'store_size',
      'store_weekly_sales',
      'fuel_price',
      'store_temperature',
      'unemployment',
      'cpi',
      'markdown1','markdown2','markdown3','markdown4','markdown5'
    ],
    pre_hook=[
      "{{ copy_fact_raw() }}",
      "{{ copy_department_raw() }}"
    ]
  )
}}

select
  f.store_id,
  d.dept_id,
  dd.date_id,
  sd.store_size,
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
from {{ source('bronze','fact_raw') }} f
join {{ source('bronze','department_raw') }} d
  on d.store_id = f.store_id
 and d.dept_date = f.fact_date
join {{ ref('walmart_date_dim') }} dd
  on dd.store_date = f.fact_date
join {{ ref('walmart_store_dim') }} sd
  on sd.store_id = f.store_id
 and sd.dept_id  = d.dept_id

{% endsnapshot %}
