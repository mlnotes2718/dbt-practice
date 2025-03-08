{% snapshot store_snapshot %}

{{
  config(
    target_schema='snapshots',
    unique_key='store_number',
    strategy='timestamp',
    updated_at='updated_at',
  )
}}

WITH 
store AS (
    SELECT
        store_number,
        store_name,
        address,
        city,
        REGEXP_REPLACE(zip_code, r"\.0$", "") zip_code,
        county_number,
        county,
        date
    FROM
        {{ source('iowa_liquor_sales', 'sales') }}
),
grouped_data AS (
    SELECT DISTINCT
        store_number,
        store_name,
        address,
        city,
        zip_code,
        county_number,
        county,
        FIRST_VALUE(date) OVER (PARTITION BY store_number, store_name, address, city, zip_code, county_number, county ORDER BY date) start_date,
        LAST_VALUE(date) OVER (PARTITION BY store_number, store_name, address, city, zip_code, county_number, county ORDER BY date) end_date,
    FROM
        store
    QUALIFY RANK() OVER (PARTITION BY store_number, store_name, address, city, zip_code, county_number, county ORDER BY date) = 1
)
SELECT
    store_number,
    store_name,
    address,
    city,
    zip_code,
    county_number,
    county,
    CAST(start_date AS TIMESTAMP) start_at,
    CAST(LEAD(start_date) OVER (PARTITION BY store_number ORDER BY start_date) AS TIMESTAMP) as end_at,
    IF(LEAD(start_date) OVER (PARTITION BY store_number ORDER BY start_date) IS NULL, CURRENT_TIMESTAMP(), NULL) as updated_at,
FROM
    grouped_data
ORDER BY store_number, start_at, end_at

{% endsnapshot %}