from datetime import datetime, timedelta

# The DAG object; we'll need this to instantiate a DAG
from airflow import DAG

# Operators; we need this to operate!
from airflow.providers.postgres.operators.postgres import PostgresOperator

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
        schedule_interval=timedelta(minutes=5),
        start_date=datetime(2021, 1, 1),
        catchup=False,
        tags=['take-home'],
) as dag:

    # @TODO: Fill in the below
    t1 = PostgresOperator(
        task_id="create_modeled_dataset_table",
        sql="sql/create_current_weather_tbl.sql",
    )

    # @TODO: Fill in the below
    t2 = PostgresOperator(
        task_id="transform_raw_into_modelled",
        sql="sql/transform_raw_into_modelled.sql",
    )

    t3 = PostgresOperator(
        task_id="create_historical_table",
        sql="sql/create_weather_tbl.sql",
    )

    t4 = PostgresOperator(
        task_id="upsert_current_into_histweather",
        sql="sql/upsert_current_into_histweather.sql",
    )

    t5 = PostgresOperator(
        task_id="create_view_of_daily_hot_cities",
        sql="sql/create_daily_hot_cities_vw.sql",
    )

    t6 = PostgresOperator(
        task_id="create_view_of_hottest_day_per_city_per_year",
        sql="sql/create_hottest_day_per_city_per_year_vw.sql",
    )

    t7 = PostgresOperator(
        task_id="create_view_of_least_humid_city_per_weather_state",
        sql="sql/create_least_humid_city_per_weather_state_vw.sql",
    )

    t8 = PostgresOperator(
        task_id="create_view_of_moving_avg_temp_per_city",
        sql="sql/create_moving_avg_temp_per_city_vw.sql",
    )

    t1 >> t2 >> t3 >> t4 >> t5 >> [t6,t7,t8]