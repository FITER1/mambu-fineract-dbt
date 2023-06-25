{{ config(materialized='table') }}

SELECT *
FROM "public"."final_investment_transaction"
