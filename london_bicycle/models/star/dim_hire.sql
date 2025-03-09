SELECT
    rental_id,
    duration,
    bike_id,
    bike_model,
    end_station_id,
    end_station_name,
    end_date,
    start_station_id,
    start_station_name,
    start_date,
FROM {{ source('london_bicycles', 'cycle_hire') }}