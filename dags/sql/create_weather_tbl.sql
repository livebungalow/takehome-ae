CREATE TABLE IF NOT EXISTS weather (
    city_id             BIGINT,
    city_name           VARCHAR(256),
    country             VARCHAR(2),
	local_date			DATE,
    utc_recorded_at     TIMESTAMPTZ,
    tz_offset_hours     INTERVAL,
    lat                 NUMERIC(11, 8),
    lon                 NUMERIC(11, 8),
    weather_type        VARCHAR(128),
    weather_desc        VARCHAR(1024),
    measure_units       VARCHAR(16),
    visibility_pct      FLOAT,
    cloud_pct           FLOAT,
    temp_deg            FLOAT,
    humidity_pct        FLOAT,
    pressure            FLOAT,
    temp_min            FLOAT,
    temp_max            FLOAT,
    feels_like          FLOAT,
    wind_deg            FLOAT,
    wind_gust           FLOAT,
    wind_speed          FLOAT,
	sys_created_at		TIMESTAMP DEFAULT (now() at TIME ZONE 'utc'),
    PRIMARY KEY (city_id, utc_recorded_at)
);

COMMENT ON COLUMN weather.city_id IS 'The ID of the city according to OpenWeatherMap';
COMMENT ON COLUMN weather.city_name IS 'The name of the city according to OpenWeatherMap';
COMMENT ON COLUMN weather.country IS 'Two letter country code of the city according to OpenWeatherMap';
COMMENT ON COLUMN weather.local_date IS 'When the weather record was created in local date';										   
COMMENT ON COLUMN weather.utc_recorded_at IS 'When the weather record was created in UTC time';
COMMENT ON COLUMN weather.tz_offset_hours IS 'The timezone of the location where the record was created, expressed as a UTC offset in hours';
COMMENT ON COLUMN weather.lat IS 'The latitude of the location where the record was created';
COMMENT ON COLUMN weather.lon IS 'The longitude of the location where the record was created';
COMMENT ON COLUMN weather.weather_type IS 'The recorded weather';
COMMENT ON COLUMN weather.weather_desc IS 'A more precise description of the recorded weather';
COMMENT ON COLUMN weather.measure_units IS 'One of "Metric", "Imperial", or "Standard"';
COMMENT ON COLUMN weather.visibility_pct IS 'The overall visibility expressed as a pct';
COMMENT ON COLUMN weather.cloud_pct IS 'The cloud coverage expressed as a pct';
COMMENT ON COLUMN weather.temp_deg IS 'The temperature in degrees, using the scale associated with the measure_units';
COMMENT ON COLUMN weather.humidity_pct IS 'The humidity expressed as a pct';
COMMENT ON COLUMN weather.pressure IS 'The atmospheric pressure, using the appropriate units associated with the measure_units';
COMMENT ON COLUMN weather.temp_min IS 'The lowest temperature felt at that time, using the appropriate units associated with the measure_units';
COMMENT ON COLUMN weather.temp_max IS 'The highest temperature felt at that time, using the appropriate units associated with the measure_units';
COMMENT ON COLUMN weather.feels_like IS 'The perceived temperature at that time, using the appropriate units associated with the measure_units';
COMMENT ON COLUMN weather.wind_deg IS 'The direction the wind was blowing at that time, expressed as degrees bearing';
COMMENT ON COLUMN weather.wind_gust IS 'The force of the wind gusts at that time';
COMMENT ON COLUMN weather.wind_speed IS 'The speed of the wind in units associated with the measure_units';
COMMENT ON COLUMN weather.sys_created_at IS 'When an entry is created at the table';									   