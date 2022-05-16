import json
import logging
import os
import typing as t

import requests


def get_current_weather(
    city_id: str,
    units: str = "metric",
    api_key: t.Optional[str] = None,
) -> dict:
    """
    Get the current weather.

    API Docs: https://openweathermap.org/current
    """
    # Test inputs
    assert city_id.isnumeric
    assert units in ['metric', 'standard', 'imperial']

    base_url: str = "http://api.openweathermap.org/data/2.5/weather"
    params = dict(
        appid=api_key or os.getenv("OPENWEATHER_API_KEY"),
        id=city_id,
        units=units,
    )
    response = requests.get(base_url, params=params, timeout=10)
    response.raise_for_status()
    return response.json()
