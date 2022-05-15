-- DROP Statement.
-- DROP MATERIALIZED VIEW IF EXISTS hot_cities;

-- Create Matview Statment
CREATE MATERIALIZED VIEW IF NOT EXISTS hot_cities
AS
    WITH base AS (
        SELECT
        utc_recorded_at::date as day,
        dense_rank() OVER (PARTITION BY city_id , utc_recorded_at::date ORDER BY temp_deg DESC, utc_recorded_at DESC) as ranked,
        *
        FROM current_weather
    )

    SELECT * FROM base
    WHERE ranked = 1
    ORDER by day DESC, temp_deg DESC
    ;
-- Refresh Matview
REFRESH MATERIALIZED VIEW hot_cities;


-- SELECT Statement
-- SELECT * FROM hot_cities;