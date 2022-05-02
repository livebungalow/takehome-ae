CREATE or REPLACE VIEW moving_avg_temp_per_city AS
--rank reading by city
WITH rank_readings AS (
    SELECT city_name, 
		country,
		utc_recorded_at,
		temp_deg,
		ROW_NUMBER() OVER (PARTITION BY city_name, country ORDER BY utc_recorded_at DESC) AS rn
	FROM weather	
),--average the last 5 readings per city
moving_avg_temp AS (
	SELECT city_name, 
		country,
		AVG(temp_deg) AS avg_temp_deg
	FROM rank_readings
	WHERE rn<=5
	GROUP BY city_name, country
)

SELECT * FROM moving_avg_temp