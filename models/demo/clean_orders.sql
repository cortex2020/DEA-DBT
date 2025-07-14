{{
    config
    (
        materialized='ephemeral'
    )
}}
with base_orders as
(
    SELECT
        ORDER_ID,
        ORDER_DATE,
        CUSTOMER_ID,
        CASE WHEN CUSTOMER_NAME IS NULL THEN 'NA' ELSE UPPER(CUSTOMER_NAME) END AS CUSTOMER_NAME,
        CREATED_AT
    FROM {{source('orders','BASE_ORDERS')}}
    WHERE ORDER_DATE is not null
)


SELECT * FROM base_orders