{{ config(materialized='table') }}

SELECT *
FROM "public"."final_wallet_transaction"
