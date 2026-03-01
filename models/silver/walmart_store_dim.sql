{{ config(
    materialized = 'incremental',
    unique_key = ['store_id','dept_id'],
    incremental_strategy = 'merge',
    pre_hook = ["{{ copy_store_raw() }}", "{{ copy_department_raw() }}"],
    merge_update_columns = ['store_type','store_size','update_date'],
    merge_exclude_columns = ['insert_date']
) }}

with stores as (
  select
    store_id,
    store_type,
    size as store_size
  from {{ source('bronze','STORE_RAW') }}
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
