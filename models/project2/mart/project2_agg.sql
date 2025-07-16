{{
    config
    (
        materialized = 'table',
        schema = 'AGG'
    )
}}

SELECT * FROM {{ ref('project2_mart') }} 
WHERE name in ('abc')