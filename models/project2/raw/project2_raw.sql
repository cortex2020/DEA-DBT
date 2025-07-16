{{
    config
    (
        materialized = 'table'
    )
}}

SELECT 'abs' AS name 
UNION
SELECT 'xyz' AS name
UNION
SELECT 'bcd' AS name 