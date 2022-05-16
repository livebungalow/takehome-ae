CREATE TABLE IF NOT EXISTS dim_cities (
    id                  BIGINT,
    city_name           VARCHAR(256),
    country             VARCHAR(2),
    lat                 NUMERIC(11, 8),
    lon                 NUMERIC(11, 8),
    created_at          TIMESTAMPTZ,
    updated_at          TIMESTAMPTZ,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN dim_cities.id IS 'The ID of the city according to OpenWeatherMap';
COMMENT ON COLUMN dim_cities.city_name IS 'The name of the city according to OpenWeatherMap';
COMMENT ON COLUMN dim_cities.country IS 'Two letter country code of the city according to OpenWeatherMap';
COMMENT ON COLUMN dim_cities.lat IS 'The latitude of the location where the record was created';
COMMENT ON COLUMN dim_cities.lon IS 'The longitude of the location where the record was created';
COMMENT ON COLUMN dim_cities.created_at IS 'When the city record was first taken from the OpenWeatherMap API';
COMMENT ON COLUMN dim_cities.updated_at IS 'When this row was most recently updated';
