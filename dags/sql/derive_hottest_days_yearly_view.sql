CREATE OR REPLACE VIEW hottest_days_per_city_year AS
/* Rank days per calendar year + city, ordered by max temperature */
WITH days_ranked AS (
    SELECT city_id
        ,day
        ,DATE_TRUNC('year', day) AS year
        ,max_temp
        /* Use RANK() to include all dates in ties */
        ,RANK() OVER (
            PARTITION BY city_id, DATE_TRUNC('year', day)
            ORDER BY max_temp DESC
        ) AS rank_max_temp_desc
    FROM highest_temp_per_city_day
)
/* Extract top 7 hottest days based on above rank */
SELECT 
    dr.year
    ,c.city_name
    ,dr.rank_max_temp_desc
    ,dr.day
    ,dr.max_temp
FROM days_ranked dr 
JOIN dim_cities c 
    ON dr.city_id = c.id
WHERE dr.rank_max_temp_desc <= 7
ORDER BY dr.year
    ,c.city_name
    ,dr.rank_max_temp_desc