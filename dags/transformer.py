from datetime import datetime, timedelta

# The DAG object; we'll need this to instantiate a DAG
from airflow import DAG

# Operators; we need this to operate!
from airflow.providers.postgres.operators.postgres import PostgresOperator

# Operator wrapper for calling PostgresWrapper on scripts in "sql" subfolder
def PostgresWrapper(script: str) -> PostgresOperator:
    return PostgresOperator(
        task_id=script,
        sql=f"sql/{script}.sql",
    )

# These args will get passed on to each operator
# You can override them on a per-task basis during operator initialization
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email': ['airflow@example.com'],
    'retries': 1,
    'retry_delay': timedelta(minutes=5)
}
with DAG(
        'transformer',
        default_args=default_args,
        description='To transform the raw current weather to a modeled dataset',
        schedule_interval=None,#timedelta(minutes=5),
        start_date=datetime(2021, 1, 1),
        catchup=False,
        tags=['take-home'],
) as dag:

    #############################
    # Create modeled tables
    #############################

    # Create dimension table for cities
    t_create_dim_cities_table = PostgresWrapper("create_dim_cities_table")
    # Create dimension table for weather types
    t_create_dim_weather_types_table = PostgresWrapper("create_dim_weather_types_table")
    # Create main weather table
    t_create_current_weather_table = PostgresWrapper("create_current_weather_table")

    #############################
    # Load dimension tables
    #############################

    # Load dimension table for cities
    t_transform_dim_cities_table = PostgresWrapper("transform_dim_cities_table")
    # Load dimension table for weather types
    t_transform_dim_weather_type_table = PostgresWrapper("transform_dim_weather_type_table")
    # Finally, load main weather table
    t_transform_weather_table = PostgresWrapper("transform_weather_table")

    #############################
    # Create intermediate views
    #############################
    
    # Hottest temperature per city per day
    t_derive_highest_temp_daily_view = PostgresWrapper("derive_highest_temp_daily_view")
    # Current_weather records, ranked by recency
    t_derive_current_weather_info_ranked_view = PostgresWrapper("derive_current_weather_info_ranked_view")

    #############################
    # Create final derived views
    #############################

    # Q1: Top hot cities in your city list per day
    t_derive_hottest_cities_daily_view = PostgresWrapper("derive_hottest_cities_daily_view")
    # Q2: Top 7 hottest day per city in each calendar year
    t_derive_hottest_days_yearly_view = PostgresWrapper("derive_hottest_days_yearly_view")
    # Q3: Latest weather information per city
    t_derive_latest_weather_info_view = PostgresWrapper("derive_latest_weather_info_view")
    # Q4: The least humid city per country
    t_derive_least_humid_city_per_country_view = PostgresWrapper("derive_least_humid_city_per_country_view")
    # Q5: Moving average of the temperature per city for 5 readings
    t_derive_moving_avg_temperature_view = PostgresWrapper("derive_moving_avg_temperature_view")

    #############################
    # Set task order
    #############################

    # Dimension tables need be loaded first
    t_create_dim_cities_table >> t_transform_dim_cities_table
    t_create_dim_weather_types_table >> t_transform_dim_weather_type_table

    # Once both finish, we can load core weather table
    [t_transform_dim_cities_table, t_transform_dim_weather_type_table] \
        >> t_create_current_weather_table >> t_transform_weather_table 

    # Then we can load intermediate views, plus Q4 view which has no dependencies
    t_transform_weather_table >> [
        t_derive_highest_temp_daily_view, 
        t_derive_current_weather_info_ranked_view, 
        t_derive_least_humid_city_per_country_view,
    ]

    # After each intermediate view finishes, we can run downstream tasks
    t_derive_highest_temp_daily_view >> [
        t_derive_hottest_cities_daily_view,
        t_derive_hottest_days_yearly_view,
    ]
    t_derive_current_weather_info_ranked_view >> [
        t_derive_latest_weather_info_view, 
        t_derive_moving_avg_temperature_view,
    ]