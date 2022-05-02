CREATE or REPLACE VIEW least_humid_city_per_weather_state AS
--rank the humidity_pct per weather state
WITH rank_humidity AS (
    SELECT city_name,
		country,
		humidity_pct,
		ROW_NUMBER() OVER (ORDER BY humidity_pct ASC) AS rnk
	FROM current_weather	
)
--get the least humid city
SELECT city_name,
	country,
	humidity_pct
FROM rank_humidity
WHERE rnk=1