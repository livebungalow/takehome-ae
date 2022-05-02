--Truncate table before loading interim data
TRUNCATE TABLE current_weather;

--Insert transformed data from raw
INSERT INTO current_weather (city_id,city_name,country,utc_recorded_at,tz_offset_hours,lat,lon,weather_type,weather_desc,measure_units,visibility_pct,cloud_pct,temp_deg,humidity_pct,pressure,temp_min,temp_max,feels_like,wind_deg,wind_gust,wind_speed)
SELECT 
    city_id::BIGINT,
    raw_data->>'name'::VARCHAR(256) AS city_name,
    (raw_data->'sys'->>'country')::VARCHAR(2) AS country,
    (to_timestamp(unix_time_seconds) AT TIME ZONE 'UTC')::TIMESTAMPTZ AS utc_recorded_at,
    (tz_offset_seconds || ' seconds')::interval AS tz_offset_hours,
    (raw_data->'coord'->>'lat')::NUMERIC(11, 8) AS lat,
    (raw_data->'coord'->>'lon')::NUMERIC(11, 8) AS lon,
    (weather->>'main')::VARCHAR(128) AS weather_type,
    (weather->>'description')::VARCHAR(1024) AS weather_desc,
    'Metric' AS measure_units,
    (raw_data->>'visibility')::FLOAT AS visibility_pct,
    (raw_data->'clouds'->>'all')::FLOAT AS cloud_pct,
    (raw_data->'main'->>'temp')::FLOAT AS temp_deg,
    (raw_data->'main'->>'humidity')::FLOAT AS humidity_pct,
    (raw_data->'main'->>'pressure')::FLOAT AS pressure,
    (raw_data->'main'->>'temp_min')::FLOAT AS temp_min,
    (raw_data->'main'->>'temp_max')::FLOAT AS temp_max,
    (raw_data->'main'->>'feels_like')::FLOAT AS feels_like,
    (raw_data->'wind'->>'deg')::FLOAT AS wind_deg,
    (raw_data->'wind'->>'gust')::FLOAT AS wind_gust,
    (raw_data->'wind'->>'speed')::FLOAT AS wind_speed
FROM raw_current_weather,
jsonb_array_elements(raw_data->'weather') weather;