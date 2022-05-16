CREATE OR REPLACE VIEW highest_temp_per_city_day AS
/* For each day and city, find its highest recorded temperature */
SELECT city_id
    ,CAST(utc_recorded_at AS DATE) AS day
    ,MAX(temp_max) AS max_temp
FROM current_weather
GROUP BY 
    city_id
    ,CAST(utc_recorded_at AS DATE)