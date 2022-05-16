
## START UP INSTRUCTION
- Navitage to http://localhost:8080/home after startup
- airflow webserver username and password: airflow, airflow


## TODO Instructions
- increase the numeber of cities from 2 to 10
- write the transformations in sql files and update the python dag
- populate the current_weather table
- create matview for the remaining datasets.
- The downstream customer(s) would read both original and derived tables.
- They will execute historical queries to run analytics and science models.

## Deliverables
- Your Python code for data fetcher and transformer.
- create data models (1 table and a couple of matviews)
    - Top hot cities in your city list per day (matview_top_hot_cities.sql)
    - Top 7 hottest day per city in each calendar year (matview_top_hot_days_per_calendar_year.sql)
    - An UPSERT dataset that keeps the latest weather information per city (latest_weather.sql)
    - The least humid city per country (matview_least_humid_city_per_country.sql)
    - Moving average of the temperature per city for 5 readings (matview_moving_average.sql)
    - The data model SQL and your design for its data modelling (see files under /dags/sql)
    - Readme file with your notes (this is the file)