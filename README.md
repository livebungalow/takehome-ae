# Bungalow Take Home Project for Analytics Engineer Role (V1. 2022-03-03)

## Work items
Amendments made are as follows:
- **fetcher.py**
  - Added 10 more cities_id to retrieve more weather data
  - Added 'TRUNCATE TABLE raw_current_weather' statement before 'INSERT' data to clear the target table before loading, seeing raw_current_weather table as loading zone
- **transformer.py**
  - Added 7 tasks pointing to sql file in dags\sql path to execute
  - Created dependency of tasks i.e t6,t7,t8 to run parallelly after task 5
- **t1: create_current_weather_tbl.sql**
  - no change
- **t2: transform_raw_into_modelled.sql**
  - truncate the current_weather table before loading
  - convert json element values to columns
  - set 'Metric' as the value of 'measure_units' column (based on params in openweather.py)
- **t3: create_weather_tbl.sql**
  - create weather table with the same structure of current_weather table to store historical weather data
  - add additional column of 'local_date' for use in the data analysis later on
- **t4: upsert_current_into_histweather.sql**
  - this is to achieve task 'An UPSERT dataset that keeps the latest weather information per city'
  - load interim data from current_weather table to weather table
  - set the value of 'local_date' column to utc_recorded_at+tz_offset_hours
- **t5 : create_daily_hot_cities_vw.sql**
  - this is to achieve task 'Top hot cities in your city list per day'
  - created a view with local_date, city and maximum temperature on a day
  - assumption: there are 3 temperature related columns to define temperature. I chose temp_deg column since it is more reflective of current temperature reading and apply MAX() to get the highest value in the grouping
  - assumption: there is no definition of 'hot', so no 'filter' clause is used. For future, possibly I could come up with a parameter of base temperature for benchmark
- **t6 : create_hottest_day_per_city_per_year_vw.sql**
  - this is to achieve task 'Top 7 hottest day per city in each calendar year'
  - created a view using the model of existing view daily_hot_cities
  - t5 will need to run after completion of t4 for the dependency
  - assumption: same assumption as 't4' applies for the definition of 'hot'
- **t7 : create_least_humid_city_per_weather_state_vw.sql**
  - this is to achieve task 'The least humid city per state'
  - assumption: there is a confusion of the word 'state'. Initially I thought state=country,
  however thinking further, 'state' can also mean in the context of 'the weather state' at each reading. Hence, I applied the logic based on the latter understanding
  - created a view that rank the cities in the current_weather table by humidity_pct and get the lowest value. Current_weather table is used due to the interim state as it is last polling
- **t8 : create_moving_avg_temp_per_city_vw.sql**
  - this is to achieve task 'Moving average of the temperature per city for 5 readings'
  - assumption: 5 readings is the 5 most recent readings

## If I Had More Time
- I faced issues with docker for provisioning, mainly because of the memory resource limitation on my workspace despite memory capping. Thus, I had to run python script manually and sql scripts on local postgres. If I had more time, I would attempt to run the project end-to-end and to learn and better test the airflow task execution
- I would wait for a week or two in order to have enought data to test the model 'Top 7 hottest day per city in each calendar year'
- I would further decide whether to persist the models into permanent tables given that the weather table will keep on growing. Currently they are made into Views for the purpose of easy-of-use
- I would seek more clarity on each of the model requirement to clear up the assumptions that I had/made