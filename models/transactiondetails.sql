{{ config(materialized='table') }}

SELECT *
FROM "public"."transactiondetails"