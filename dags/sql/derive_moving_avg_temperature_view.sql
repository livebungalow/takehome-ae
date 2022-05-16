CREATE OR REPLACE VIEW moving_average_temperature_view AS
/* Calculate moving average over last 5 readings */
WITH moving_avg_temp_per_city AS (
    SELECT 
        city_id
        ,AVG(temp_deg) AS avg_temp_last_five_readings
    FROM current_weather_ranked_by_recency_view
    WHERE rank_utc_recorded_at_desc <= 5
    GROUP BY city_id
)
/* Join to dim_cities to get city name */
SELECT 
    c.city_name
    ,mat.avg_temp_last_five_readings
FROM moving_avg_temp_per_city mat
JOIN dim_cities c
    ON mat.city_id = c.id
ORDER BY c.city_name