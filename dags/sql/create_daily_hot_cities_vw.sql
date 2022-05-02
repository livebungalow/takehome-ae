CREATE or REPLACE VIEW daily_hot_cities AS
	SELECT local_date, 
		city_name,
		country,
		MAX(temp_deg) AS hottest_temp_deg
    FROM weather
    GROUP BY local_date, city_name, country
    ORDER BY local_date, hottest_temp_deg DESC,city_name, country