{{ config(materialized='table') }}

SELECT *
FROM "public"."savingsproduct"
