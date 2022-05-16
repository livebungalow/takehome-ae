import json
import typing as t
from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator


def ingest_api_data(city_ids: t.List[str]) -> t.List[t.Tuple]:
    """
    Pull payload from OpenWeatherAPI from a list of city IDs.
    """
    from openweather import get_current_weather

    rows = []
    for city_id in city_ids:
        payload = get_current_weather(city_id=city_id)
        if payload:
            rows.append(
                (
                    payload["id"],
                    payload["dt"],
                    payload["timezone"],
                    json.dumps(payload),
                )
            )
    return rows


def construct_insert_statement(**context) -> str:
    """
    Using result from ingest_api_data, construct INSERT INTO ... VALUES statement string.
    """
    rows = context["ti"].xcom_pull(key="return_value", task_ids="ingest_api_data")
    value_rows = [
        "({}, {}, {}, '{}', {}, {})".format(
            row[0], row[1], row[2], row[3], "now()", "now()"
        )
        for row in rows
    ]
    values_stmt = ",\n".join(value_rows)

    return f"""
        SET TIME ZONE 'UTC';

        INSERT INTO raw_current_weather (city_id, unix_time_seconds, tz_offset_seconds, raw_data, created_at, updated_at)
            VALUES
                {values_stmt}

        ON CONFLICT (city_id, unix_time_seconds) DO
            UPDATE SET
                tz_offset_seconds = EXCLUDED.tz_offset_seconds,
                raw_data = EXCLUDED.raw_data,
                updated_at = EXCLUDED.updated_at
        """


default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email": ["airflow@example.com"],
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    "fetcher",
    default_args=default_args,
    description="To fetch the weather data",
    start_date=datetime(2021, 1, 1, 0, 0, 0),
    schedule_interval="0 */1 * * *",
    catchup=False,
    tags=["take-home"],
) as dag:

    t1 = PostgresOperator(
        task_id="create_raw_dataset",
        sql="sql/create_raw_current_weather_tbl.sql",
    )

    t2 = PythonOperator(
        task_id="ingest_api_data",
        python_callable=ingest_api_data,
        retries=1,
        op_kwargs={
            "city_ids": [
                "5128581",  # New York
                "5391811",  # San Deigo
                "5809844",  # Seattle
                "4164138",  # Miami
                "4671654",  # Austin
                "4684888",  # Dallas
                "4930956",  # Boston
                "5746545",  # Portland
                "5506956",  # Las Vegas
                "5419384",  # Denver
            ],  # KW, London (ON)
        },
    )

    t3 = PythonOperator(
        task_id="construct_insert_statement",
        python_callable=construct_insert_statement,
        provide_context=True,
    )

    t4 = PostgresOperator(
        task_id="insert_into_raw_dataset",
        sql="{{ ti.xcom_pull(key='return_value', task_ids='construct_insert_statement') }}",
    )

    t1 >> t2 >> t3 >> t4
