SELECT DISTINCT
    store_number,
    store_name,
    address,
    city,
    zip_code,
FROM {{ ref('store_snapshot') }}
WHERE CURRENT_TIMESTAMP > dbt_valid_from and dbt_valid_to IS NULL