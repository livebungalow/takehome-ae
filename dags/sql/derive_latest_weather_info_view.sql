CREATE OR REPLACE VIEW latest_weather_information AS
/* For each city, pull the latest weather info based on above rank.
    Since we ranked by utc_recorded_at, results should be unique on city_id.
*/
SELECT 
    city_id
    ,utc_recorded_at
    ,tz_offset_hours
    ,weather_id
    ,measure_units
    ,visibility_pct
    ,cloud_pct
    ,temp_deg
    ,humidity_pct
    ,pressure
    ,temp_min
    ,temp_max
    ,feels_like
    ,wind_deg
    ,wind_gust
    ,wind_speed
    ,created_at
    ,updated_at
FROM current_weather_ranked_by_recency_view
WHERE rank_utc_recorded_at_desc = 1