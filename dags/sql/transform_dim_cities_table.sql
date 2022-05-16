/* If any part of the below goes wrong, we want to revert.
   So we wrap the whole transformation in a transaction block.
*/
BEGIN TRANSACTION;
    /* Since raw table has full historical data, 
       we can truncate and recreate the table.
       While this is not the most performant, 
       it's a safer option in terms of data quality.
    */
    ALTER TABLE current_weather DROP CONSTRAINT FK_city_id;
    TRUNCATE TABLE dim_cities;

    /* Add new city entries to dimension table,
    and update existing city records with latest metadata
    */
    INSERT INTO dim_cities
        (id,city_name,country,lat,lon,created_at,updated_at)
    SELECT id
        ,city_name
        ,country
        ,lat
        ,lon
        ,created_at
        ,updated_at
    FROM (
        SELECT DISTINCT
            CAST(raw_data->>'id' AS BIGINT) AS id
            ,raw_data->>'name' AS city_name
            ,raw_data#>>'{sys,country}' AS country
            ,CAST(raw_data#>>'{coord,lat}' AS NUMERIC(11, 8)) AS lat
            ,CAST(raw_data#>>'{coord,lon}' AS NUMERIC(11, 8)) AS lon
            ,created_at
            ,updated_at
            ,ROW_NUMBER() OVER (
                PARTITION BY CAST(raw_data->>'id' AS BIGINT)
                ORDER BY updated_at DESC
            ) AS rown_updated_at_desc
        FROM raw_current_weather
    ) AS raw_current_weather_ranked
    WHERE rown_updated_at_desc = 1;

    /* Add back Foreign Key once we create the table */
    ALTER TABLE current_weather ADD CONSTRAINT FK_city_id 
        FOREIGN KEY (city_id) 
        REFERENCES dim_cities (id);

COMMIT;