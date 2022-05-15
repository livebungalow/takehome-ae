-- DROP Statement.
-- DROP MATERIALIZED VIEW IF EXISTS hot_cities;

-- Create Matview Statment
CREATE MATERIALIZED VIEW IF NOT EXISTS hot_cities
AS
    SELECT * FROM current_weather
    WHERE utc_recorded_at = (SELECT MAX(utc_recorded_at) FROM current_weather)
    ORDER BY temp_deg DESC
    LIMIT 5;

-- Refresh Matview
REFRESH MATERIALIZED VIEW hot_cities;


-- SELECT Statement
-- SELECT * FROM hot_cities;