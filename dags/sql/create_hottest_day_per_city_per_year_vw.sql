CREATE or REPLACE VIEW hottest_day_per_city_per_year AS
--rank cities in daily_hot_cities view by the hottest day
WITH rank_hottest_day_per_city AS (
    SELECT DATE_PART('year',local_date) AS calendar_year,
		local_date,
		city_name,
		country, 
		hottest_temp_deg,
		ROW_NUMBER() OVER (PARTITION BY DATE_PART('year',local_date), city_name, country ORDER BY hottest_temp_deg DESC) AS rn
	FROM daily_hot_cities
)
--get top 7 hottest day per year
SELECT calendar_year,
	local_date,
	city_name,
	country, 
	hottest_temp_deg 
FROM rank_hottest_day_per_city
WHERE rn<=7