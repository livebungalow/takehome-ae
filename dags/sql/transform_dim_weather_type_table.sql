/* If any part of the below goes wrong, we want to revert.
   So we wrap the whole transformation in a transaction block.
*/
BEGIN TRANSACTION;
    /* Since raw table has full historical data, 
       we can truncate and recreate the table.
       While this is not the most performant, 
       it's a safer option in terms of data quality.
    */
    ALTER TABLE current_weather DROP CONSTRAINT FK_weather_id;
    TRUNCATE TABLE dim_weather_types;

    /* Add new weather type entries to dimension table,
    and update existing weather type records with latest metadata
    */
    INSERT INTO dim_weather_types
        (id, weather_type, weather_desc,created_at,updated_at)
    SELECT id
        ,weather_type
        ,weather_desc
        ,created_at
        ,updated_at
    FROM (
        SELECT DISTINCT
            CAST(raw_data#>>'{weather,id}' AS INT) AS id
            ,raw_data#>>'{weather,main}' AS weather_type
            ,raw_data#>>'{weather,description}' AS weather_desc
            ,created_at
            ,updated_at
            ,ROW_NUMBER() OVER (
                PARTITION BY CAST(raw_data#>>'{weather,id}' AS INT)
                ORDER BY updated_at DESC
            ) AS rown_updated_at_desc
        FROM raw_current_weather
        WHERE raw_data#>>'{weather,id}' IS NOT NULL
    ) AS raw_current_weather_ranked
    WHERE rown_updated_at_desc = 1;

    /* Add back Foreign Key once we create the table */
    ALTER TABLE current_weather ADD CONSTRAINT FK_weather_id 
        FOREIGN KEY (weather_id) 
        REFERENCES dim_weather_types (id);

COMMIT;