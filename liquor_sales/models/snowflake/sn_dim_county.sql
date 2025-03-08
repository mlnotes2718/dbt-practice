SELECT DISTINCT
    county_number,
    county,
FROM {{ ref('store_snapshot') }}
WHERE county_number IS NOT NULL