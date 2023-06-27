{{ config(materialized='table') }}

SELECT *
FROM "public"."disbursementdetails"