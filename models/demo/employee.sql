{{
    config
    (
        materialized = 'table'
    )
}}



WITH employee_raw AS 
(
    SELECT 
        EMPID AS emp_id,
        SPLIT_PART(NAME, ' ', 1) AS emp_firstname,
        SPLIT_PART(NAME, ' ', 2) AS emp_lastname,
        SALARY AS emp_salary,
        HIREDATE AS emp_hiredate,
        SPLIT_PART(ADDRESS, ',', 1) AS emp_street,
        SPLIT_PART(ADDRESS, ',', 2) AS emp_city,
        SPLIT_PART(ADDRESS, ',', 3) AS emp_country,
        SPLIT_PART(ADDRESS, ',', 4) AS emp_zipcode
    FROM {{source('employee', 'EMPLOYEE_RAW')}} --DBT_DB.PUBLIC.EMPLOYEE_RAW
)
SELECT * FROM employee_raw