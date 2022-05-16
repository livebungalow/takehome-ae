CREATE OR REPLACE VIEW hottest_cities_per_day AS
/* First rank each city per day, based on highest temperature */
WITH cities_ranked AS (
    SELECT city_id
        ,day
        ,max_temp
        /* Use RANK() to include all cities in ties */
        ,RANK() OVER (
            PARTITION BY day
            ORDER BY max_temp DESC
        ) AS rank_max_temp_desc
    FROM highest_temp_per_city_day
)
/* Find hottest city per day based on above rank */
SELECT 
    cr.day
    ,c.city_name
    ,cr.max_temp
FROM cities_ranked cr 
JOIN dim_cities c 
    ON cr.city_id = c.id
WHERE cr.rank_max_temp_desc = 1
ORDER BY cr.day