{{ config(materialized='table') }}

WITH role_decoded AS (
    SELECT 
        ROW_NUMBER() OVER ()+(SELECT MAX(id) FROM "public"."m_role") as id,
        "NAME" as name,
        'No description available' as description,
        FALSE as is_disabled
    FROM {{ ref('role') }} 
)

SELECT * FROM role_decoded