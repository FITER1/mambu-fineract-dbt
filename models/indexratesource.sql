{{ config(materialized='table') }}

SELECT *
FROM "public"."indexratesource"