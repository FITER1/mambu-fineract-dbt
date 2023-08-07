{{ config(materialized='table') }}

SELECT *
FROM "public"."savingsaccount"
