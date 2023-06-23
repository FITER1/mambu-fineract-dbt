{{ config(materialized='table') }}

SELECT *
FROM "public"."indexrate"