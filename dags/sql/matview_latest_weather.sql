-- DROP Statement.
-- DROP MATERIALIZED VIEW IF EXISTS latest_weather;

-- Create Matview Statment
CREATE MATERIALIZED VIEW IF NOT EXISTS latest_weather
AS
    SELECT * FROM current_weather
    WHERE utc_recorded_at = (SELECT MAX(utc_recorded_at) FROM current_weather);

-- Refresh Matview
REFRESH MATERIALIZED VIEW latest_weather;


-- SELECT Statement
-- SELECT * FROM latest_weather;