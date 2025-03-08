SELECT
    store_number,
    store_name,
    address,
    city,
    zip_code,
    county_number,
    county,
FROM {{ ref('store_snapshot') }}
WHERE CURRENT_TIMESTAMP > dbt_valid_from and dbt_valid_to IS NULL