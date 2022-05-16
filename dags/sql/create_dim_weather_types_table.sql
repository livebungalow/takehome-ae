CREATE TABLE IF NOT EXISTS dim_weather_types (
    id                     INT,
    weather_type        VARCHAR(128),
    weather_desc        VARCHAR(1024),
    created_at          TIMESTAMPTZ,
    updated_at          TIMESTAMPTZ,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN weather_types.id IS 'The recorded weather ID';
COMMENT ON COLUMN weather_types.weather_type IS 'The recorded weather';
COMMENT ON COLUMN weather_types.weather_desc IS 'A more precise description of the recorded weather';
COMMENT ON COLUMN weather_types.created_at IS 'When the weather record was first taken from the OpenWeatherMap API';
COMMENT ON COLUMN weather_types.updated_at IS 'When this row was most recently updated';
