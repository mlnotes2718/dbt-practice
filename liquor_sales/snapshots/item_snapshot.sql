{% snapshot item_snapshot %}

{{
  config(
    target_schema='snapshots',
    unique_key='item_number',
    strategy='timestamp',
    updated_at='updated_at',
  )
}}


WITH 
item AS (
    SELECT
        item_number,
        item_description,
        category,
        category_name,
        vendor_number,
        vendor_name,
        pack,
        bottle_volume_ml,
        date
    FROM
        {{ source('iowa_liquor_sales', 'sales') }}
),
grouped_data AS (
    SELECT DISTINCT
        item_number,
        item_description,
        category,
        category_name,
        vendor_number,
        vendor_name,
        pack,
        bottle_volume_ml,
        FIRST_VALUE(date) OVER (PARTITION BY item_number, item_description, category, category_name, vendor_number, vendor_name, pack, bottle_volume_ml ORDER BY date) start_date,
        LAST_VALUE(date) OVER (PARTITION BY item_number, item_description, category, category_name, vendor_number, vendor_name, pack, bottle_volume_ml ORDER BY date) end_date,
    FROM
        item
    QUALIFY RANK() OVER (PARTITION BY item_number, item_description, category, category_name, vendor_number, vendor_name, pack, bottle_volume_ml ORDER BY date) = 1
)
SELECT
    item_number,
    item_description,
    category,
    category_name,
    vendor_number,
    vendor_name,
    pack,
    bottle_volume_ml,
    CAST(start_date AS TIMESTAMP) as start_at,
    CAST(LEAD(start_date) OVER (PARTITION BY item_number ORDER BY start_date) AS TIMESTAMP) as end_at,
    IF(LEAD(start_date) OVER (PARTITION BY item_number ORDER BY start_date) IS NULL, CURRENT_TIMESTAMP(), NULL) as updated_at,
FROM
    grouped_data
ORDER BY item_number, start_at, end_at

{% endsnapshot %}