{{ config(materialized='table') }}

WITH source AS (
    SELECT
        encodedkey as external_id,
        "ID" as id,
        "NAME" AS name,
        CREATIONDATE as opening_date
    FROM branch
)

SELECT
    id::int8 as id,
    CAST(NULL AS int8) as parent_id,
    '.' as hierarchy,
    external_id,
    name,
    opening_date
FROM source