CREATE TABLE IF NOT EXISTS raw_current_weather (
    city_id                     BIGINT,
    unix_time_seconds           BIGINT,
    tz_offset_seconds           INTEGER,
    raw_data                    JSONB,
    units                       VARCHAR(16),
    created_at                  TIMESTAMPTZ,
    updated_at                  TIMESTAMPTZ,
    PRIMARY KEY (city_id, unix_time_seconds)
);

COMMENT ON COLUMN raw_current_weather.city_id IS 'The ID of the city according to OpenWeatherMap';
COMMENT ON COLUMN raw_current_weather.unix_time_seconds IS 'The time the record was created, expressed in integer seconds elapsed since 1970-01-01';
COMMENT ON COLUMN raw_current_weather.tz_offset_seconds IS 'How many seconds off of UTC the timezone the record was created in was';
COMMENT ON COLUMN raw_current_weather.raw_data IS 'The payload returned from the OpenWeatherMap API';
COMMENT ON COLUMN raw_current_weather.units IS 'One of "metric", "imperial", or "standard"';
COMMENT ON COLUMN raw_current_weather.created_at IS 'When the payload was first taken from the OpenWeatherMap API';
COMMENT ON COLUMN raw_current_weather.updated_at IS 'When this row was most recently updated';
