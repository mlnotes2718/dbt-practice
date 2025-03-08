SELECT DISTINCT
    vendor_number,
    vendor_name,
FROM {{ ref('item_snapshot') }}
WHERE vendor_number IS NOT NULL