{{
    config
    (
        materialized = 'table'
    )
}}

SELECT * FROM {{ ref('project2_raw') }} 
WHERE name in ('xyz', 'abc')