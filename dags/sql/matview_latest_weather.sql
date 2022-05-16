-- DROP Statement.
-- DROP MATERIALIZED VIEW IF EXISTS latest_weather;

-- Create Matview Statment
CREATE MATERIALIZED VIEW IF NOT EXISTS latest_weather
AS
    WITH base as (
    SELECT 
    dense_rank() OVER (PARTITION BY city_id ORDER BY utc_recorded_at DESC) as ranked,
    * 
    FROM current_weather
    )
    SELECT * FROM base WHERE ranked = 1;


-- Refresh Matview
REFRESH MATERIALIZED VIEW latest_weather;


-- SELECT Statement
-- SELECT * FROM latest_weather;