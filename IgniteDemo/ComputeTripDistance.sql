
-- This query generates a new computed row: direct_distance, using the built-in
-- fnCalculateDistance function.

SELECT 
	tipped, 
	fare_amount, 
	passenger_count,
	trip_time_in_secs,
	trip_distance, 
    pickup_datetime, 
	dropoff_datetime, 
    dbo.fnCalculateDistance(
		pickup_latitude, 
		pickup_longitude,  
		dropoff_latitude, 
		dropoff_longitude) AS direct_distance,
    pickup_latitude, 
	pickup_longitude,  
	dropoff_latitude, 
	dropoff_longitude
FROM nyctaxi_sample
TABLESAMPLE (1 PERCENT) REPEATABLE (98052)