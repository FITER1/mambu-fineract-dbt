{{ config(materialized='table') }}

SELECT *
FROM "public"."savingstransaction"
