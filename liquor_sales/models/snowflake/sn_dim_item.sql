SELECT DISTINCT
    item_number,
    item_description,
FROM {{ ref('item_snapshot') }}
WHERE CURRENT_TIMESTAMP > dbt_valid_from and dbt_valid_to IS NULL