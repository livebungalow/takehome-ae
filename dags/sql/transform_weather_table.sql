/* If any part of the below goes wrong, we want to revert.
   So we wrap the whole transformation in a transaction block.
*/
BEGIN TRANSACTION;
    /* Since raw table has full historical data, 
       we can truncate and recreate the table.
       While this is not the most performant, 
       it's a safer option in terms of data quality.
    */
    TRUNCATE TABLE current_weather;

    INSERT INTO current_weather
    SELECT 
        CAST(raw_data->>'id' AS BIGINT) AS city_id
        ,TO_TIMESTAMP(CAST(raw_data->>'dt' AS BIGINT)) AS utc_recorded_at
        ,MAKE_INTERVAL(hours => CAST(raw_data->>'timezone' AS INT) / 3600) AS tz_offset_hours /* Raw field is in seconds */
        ,CAST(raw_data#>>'{weather,id}' AS INT) AS weather_id
        ,units AS measure_units
        ,100.0 * (CAST(raw_data->>'visibility' AS INT) / 10000) AS visibility_pct /* Raw field is in meters, while max is 10km */
        ,CAST(raw_data#>>'{clouds,all}' AS FLOAT) AS cloud_pct
        ,CAST(raw_data#>>'{main,temp}' AS FLOAT) AS temp_deg
        ,CAST(raw_data#>>'{main,humidity}' AS FLOAT) AS humidity_pct
        ,CAST(raw_data#>>'{main,pressure}' AS FLOAT) AS pressure
        ,CAST(raw_data#>>'{main,temp_min}' AS FLOAT) AS temp_min
        ,CAST(raw_data#>>'{main,temp_max}' AS FLOAT) AS temp_max
        ,CAST(raw_data#>>'{main,feels_like}' AS FLOAT) AS feels_like
        ,CAST(raw_data#>>'{wind,deg}' AS FLOAT) AS wind_deg
        ,CAST(raw_data#>>'{wind,gust}' AS FLOAT) AS wind_gust
        ,CAST(raw_data#>>'{wind,speed}' AS FLOAT) AS wind_speed
        ,created_at
        ,updated_at
    FROM raw_current_weather;

COMMIT;