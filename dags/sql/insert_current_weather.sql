INSERT INTO current_weather (city_id, city_name, country, utc_recorded_at, tz_offset_hours, lat, lon, weather_type, weather_desc, measure_units, visibility_pct, cloud_pct, temp_deg, humidity_pct, pressure, temp_min, temp_max, feels_like, wind_deg, wind_gust, wind_speed)
SELECT
    CAST(raw_data -> 'id' AS INT) AS city_id,
    raw_data -> 'name' AS city_name,
    raw_data -> 'sys' ->> 'country' AS country,
    to_timestamp(unix_time_seconds) AS utc_recorded_at,
    NULL AS tz_offset_seconds,
    CAST(raw_data -> 'coord' ->> 'lat' AS FLOAT) AS lat,
    CAST(raw_data -> 'coord' ->> 'lon' AS FLOAT) AS long,
    raw_data -> 'weather' -> 0 -> 'main'  AS weather_type,
    raw_data -> 'weather' -> 0 -> 'description' AS weather_desc,
    NULL as measure_units,
    CAST(raw_data -> 'visibility' AS FLOAT) AS visibility_pct,
    CAST(raw_data -> 'clouds' ->> 'all' AS FLOAT) AS cloud_pct,
    CAST(raw_data -> 'main' ->> 'temp' AS FLOAT) AS temp_deg,
    CAST(raw_data -> 'main' ->> 'humidity' AS FLOAT) AS humidity_pct,
    CAST(raw_data -> 'main' ->> 'pressure' AS FLOAT) AS pressure,
    CAST(raw_data -> 'main' ->> 'temp_min' AS FLOAT) AS temp_min,
    CAST(raw_data -> 'main' ->> 'temp_max' AS FLOAT) AS temp_max,
    CAST(raw_data -> 'main' ->> 'feels_like' AS FLOAT) AS feels_like,
    CAST(raw_data -> 'wind' ->> 'deg' AS FLOAT) AS wind_deg,
    CAST(raw_data -> 'wind' ->> 'gust' AS FLOAT) AS wind_gust,
    CAST(raw_data -> 'wind' ->> 'speed' AS FLOAT) AS wind_speed
FROM raw_current_weather
ON CONFLICT DO NOTHING;