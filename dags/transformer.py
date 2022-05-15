from datetime import datetime, timedelta

# The DAG object; we'll need this to instantiate a DAG
from airflow import DAG

# Operators; we need this to operate!
from airflow.providers.postgres.operators.postgres import PostgresOperator

# These args will get passed on to each operator
# You can override them on a per-task basis during operator initialization
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email": ["airflow@example.com"],
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}
with DAG(
    "transformer",
    default_args=default_args,
    description="To transform the raw current weather to a modeled dataset",
    schedule_interval=timedelta(minutes=5),
    start_date=datetime(2021, 1, 1),
    catchup=False,
    tags=["take-home"],
) as dag:

    # @TODO: Fill in the below
    t1 = PostgresOperator(
        task_id="create_current_weather",
        sql="sql/create_current_weather_tbl.sql",
    )

    # @TODO: Fill in the below
    t2 = PostgresOperator(
        task_id="insert_current_weather",
        sql="sql/insert_current_weather.sql",
    )
    t3 = PostgresOperator(
        task_id="matview_moving_average",
        sql="sql/matview_moving_average.sql",
    )
    t4 = PostgresOperator(
        task_id="matview_latest_weather",
        sql="sql/matview_latest_weather.sql",
    )
    t5 = PostgresOperator(
        task_id="matview_least_humid_city_per_country",
        sql="sql/matview_least_humid_city_per_country.sql",
    )
    t6 = PostgresOperator(
        task_id="matview_top_hot_cities",
        sql="sql/matview_top_hot_cities.sql",
    )
    t7 = PostgresOperator(
        task_id="matview_top_hot_days_per_calendar_year",
        sql="sql/matview_top_hot_days_per_calendar_year.sql",
    )
    t1 >> t2
    t2 >> t3
    t2 >> t4
    t2 >> t5
    t2 >> t6
    t2 >> t7