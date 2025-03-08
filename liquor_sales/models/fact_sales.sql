SELECT
    invoice_and_item_number,
    date,
    store_number,
    item_number,
    state_bottle_cost,
    state_bottle_retail,
    bottles_sold,
    sale_dollars,
    volume_sold_liters,
    volume_sold_gallons
FROM {{ source('iowa_liquor_sales', 'sales') }}
