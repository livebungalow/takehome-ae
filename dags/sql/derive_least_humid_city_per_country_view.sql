CREATE OR REPLACE VIEW least_humid_city_per_country_view AS
/* Rank cities by humidity */
WITH cities_ranked AS (
    SELECT 
        w.city_id
        ,c.city_name
        ,w.humidity_pct
        ,c.country
        /* Use RANK() to include all cities in case of ties */
        ,RANK() OVER(
            PARTITION BY c.country
            ORDER BY w.humidity_pct ASC
        ) AS rank_humidity_pct_asc
    FROM current_weather w
    JOIN dim_cities c
        ON w.city_id = c.id
)
/* Use above rank to pull least humid city per country */
SELECT 
    country
    ,city_name
    ,humidity_pct
FROM cities_ranked
WHERE rank_humidity_pct_asc = 1
ORDER BY country