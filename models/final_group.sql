{{ config(materialized='table') }}

SELECT *
FROM "public"."final_group"