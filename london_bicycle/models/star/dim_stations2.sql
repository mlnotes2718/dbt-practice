SELECT 
    bike_hire_stations.station_id,
    bike_hire_stations.station_name,
    COALESCE(SUM(bike_hire_stations.duration), 0) AS total_duration,
    COALESCE(COUNT(bike_hire_stations.start_station_id), 0) AS start_count,
    COALESCE(COUNT(bike_hire_stations.end_station_id), 0) AS end_count
FROM {{ ref('bike_hire_stations') }} AS bike_hire_stations 
WHERE station_id IS NOT NULL
GROUP BY station_id, station_name
ORDER BY total_duration DESC