SELECT 
    end_station_name, 
    COUNT(*) AS rental_count
FROM {{ source('london_bicycles', 'cycle_hire') }}
WHERE end_station_name IS NOT NULL 
GROUP BY end_station_name
ORDER BY rental_count DESC