SELECT 
    bike_hire.duration, 
    bike_hire.start_station_id, 
    bike_hire.end_station_id, 
    bike_stations.id AS station_id, 
    bike_stations.name AS station_name,
FROM 
    {{ source('london_bicycles', 'cycle_hire') }} AS bike_hire
LEFT JOIN 
    {{ source('london_bicycles', 'cycle_stations') }} AS bike_stations
ON 
    bike_stations.id = bike_hire.start_station_id OR bike_stations.id = bike_hire.end_station_id