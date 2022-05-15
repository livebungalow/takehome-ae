-- DROP Statement.
-- DROP MATERIALIZED VIEW IF EXISTS hot_days_per_year;

-- Create Matview Statment
CREATE MATERIALIZED VIEW IF NOT EXISTS hot_days_per_year
AS
    WITH base as (SELECT
        DATE_PART('year',utc_recorded_at),
        dense_rank() OVER (PARTITION BY DATE_PART('year',utc_recorded_at), city_id ORDER BY temp_deg DESC) as ranked,
        utc_recorded_at,
        city_name,
        temp_deg
    FROM current_weather)

    SELECT * FROM base WHERE ranked=1
    ORDER BY temp_deg DESC;

-- Refresh Matview
REFRESH MATERIALIZED VIEW hot_days_per_year;


-- SELECT Statement
-- SELECT * FROM hot_days_per_year;