-- DROP Statement.
-- DROP MATERIALIZED VIEW IF EXISTS moving_average;

-- Create Matview Statment
CREATE MATERIALIZED VIEW IF NOT EXISTS moving_average
AS
    SELECT
        city_id,
        utc_recorded_at,
        temp_deg,
        AVG(temp_deg) OVER (PARTITION BY  city_id ORDER BY utc_recorded_at ASC ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS avg_temp
    FROM current_weather
    ORDER BY city_id, utc_recorded_at ASC;

-- Refresh Matview
REFRESH MATERIALIZED VIEW moving_average;


-- SELECT Statement
-- SELECT * FROM moving_average;