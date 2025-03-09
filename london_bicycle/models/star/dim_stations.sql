SELECT 
    stations.id,
    stations.name,
    COALESCE(SUM(bike_hire.duration), 0) AS total_duration,
    COALESCE(COUNT(bike_hire.start_station_id), 0) AS start_count,
    COALESCE(COUNT(bike_hire.end_station_id), 0) AS end_count
FROM {{ source('london_bicycles', 'cycle_stations') }} AS stations
LEFT JOIN {{ source('london_bicycles', 'cycle_hire') }} AS bike_hire 
    ON stations.id = bike_hire.start_station_id OR stations.id = bike_hire.end_station_id
GROUP BY stations.id, stations.name
ORDER BY total_duration DESC

