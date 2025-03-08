SELECT DISTINCT
    category,
    category_name,
FROM {{ ref('item_snapshot') }}
WHERE CURRENT_TIMESTAMP > dbt_valid_from and dbt_valid_to IS NULL and category IS NOT NULL