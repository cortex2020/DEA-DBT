{{
    config(
        materialized="incremental",
        unique_key="store_date",
        incremental_strategy="merge",
        pre_hook="{{ copy_department_raw() }}",
    )
}}


with
    src as (
        select dept_date as store_date, isholiday
        from {{ source("bronze", "department_raw") }}
        {% if is_incremental() %}
            where
                dept_date
                > (select coalesce(max(store_date), '1900-01-01'::date) from {{ this }})
        {% endif %}
    ),

    dedup as (
        select store_date, max(isholiday::int)::boolean as isholiday from src group by 1
    )

select
    {{ dbt_utils.generate_surrogate_key(["store_date"]) }} as date_id,
    store_date,
    isholiday,
    current_timestamp() as insert_date,
    current_timestamp() as update_date
from dedup
