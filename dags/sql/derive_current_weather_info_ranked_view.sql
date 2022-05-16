CREATE OR REPLACE VIEW current_weather_ranked_by_recency_view AS
/* Rank records per city based on time of extraction */
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
    /* Use ROW_NUMBER() since we want absolute latest record */
    ,ROW_NUMBER() OVER (
        PARTITION BY city_id
        ORDER BY utc_recorded_at DESC
    ) AS rank_utc_recorded_at_desc
FROM current_weather