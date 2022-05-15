-- DROP Statement.
-- DROP MATERIALIZED VIEW IF EXISTS least_humid;

-- Create Matview Statment
CREATE MATERIALIZED VIEW IF NOT EXISTS least_humid
AS
    WITH base as (SELECT
        DATE_PART('year',utc_recorded_at),
        dense_rank() OVER (PARTITION BY country, city_id ORDER BY humidity_pct ASC, utc_recorded_at DESC) as ranked,
        utc_recorded_at,
        city_name,
        country,
        humidity_pct
    FROM current_weather)

    SELECT * FROM base WHERE ranked=1
    ORDER BY humidity_pct ASC;

-- Refresh Matview
REFRESH MATERIALIZED VIEW least_humid;


-- SELECT Statement
-- SELECT * FROM least_humid;