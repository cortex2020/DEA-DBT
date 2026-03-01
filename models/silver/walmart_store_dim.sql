{{ config(
    materialized = 'incremental',
    unique_key = ['store_id','dept_id'],
    incremental_strategy = 'merge',
    pre_hook = ["{{ copy_store_raw() }}", "{{ copy_department_raw() }}"],
    merge_update_columns = ['store_type','store_size','update_date'],
) }}

with stores as (
  select
    store_id,
    store_type,
    size as store_size
  from {{ source('bronze','STORE_RAW') }}
  {% if is_incremental() %}
    where insert_dts > (select coalesce(max(update_date), '1900-01-01'::timestamp_ntz) from {{ this }})
  {% endif %}
),


depts as (
  select distinct
    store_id,
    dept_id
  from {{ source('bronze','DEPARTMENT_RAW') }}
),

final as (
  select
    d.store_id,
    d.dept_id,
    s.store_type,
    s.store_size
  from depts d
  join stores s
    on s.store_id = d.store_id
)

select
  store_id,
  dept_id,
  store_type,
  store_size,
  current_timestamp() as insert_date,
  current_timestamp() as update_date
from final
