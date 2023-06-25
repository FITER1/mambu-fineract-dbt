{{ config(materialized='table') }}

WITH base AS (
    SELECT *,
        encodedkey as external_id,
        ABS(amount) as transaction_amount,
        balance as running_balance,
        comment,
        DETAILS_ENCODEDKEY_OID,
        PARENTACCOUNTKEY,
        CREATIONDATE,
        "TYPE" as transaction_type,
        REVERSALTRANSACTIONKEY,
        LINKEDLOANTRANSACTIONKEY,
        LINKEDSAVINGSTRANSACTIONKEY,
        OVERDRAFTAMOUNT,
        ENTRYDATE
    FROM {{ ref('final_investment_transaction') }}
),

transaction_details AS (
    SELECT *
    FROM transactiondetails
)

SELECT
    ROW_NUMBER() OVER () as id,
    b.external_id,
    b.transaction_amount,
    b.PARENTACCOUNTKEY as account_external_id,
    CASE
        WHEN b.transaction_type  = 'DEPOSIT' THEN 1
        WHEN b.transaction_type = 'WITHDRAWAL' THEN 2
        WHEN b.transaction_type  = 'INTEREST_APPLIED' THEN 3
        WHEN b.transaction_type = 'FEE_APPLIED' THEN 7
        WHEN b.transaction_type = 'WITHHOLDING_TAX' THEN 18
        WHEN b.transaction_type = 'INTEREST_RATE_CHANGED' THEN 3
        WHEN b.transaction_type  = 'TRANSFER' THEN 2
        WHEN b.transaction_type = 'INTEREST_APPLIED_ADJUSTMENT' THEN 3
        WHEN b.transaction_type = 'WITHDRAWAL_ADJUSTMENT' THEN 2
        WHEN b.transaction_type = 'FEE_ADJUSTED' THEN 7
        WHEN b.transaction_type = 'WITHHOLDING_TAX_ADJUSTMENT' THEN 18
        WHEN b.transaction_type = 'TRANSFER_ADJUSTMENT' THEN 2
        ELSE 2
    END as  transaction_type_enum,
    b.comment,
    td.TRANSACTIONCHANNELKEY as transaction_channel_key,
    b.CREATIONDATE as creation_date,
    CASE WHEN b.REVERSALTRANSACTIONKEY IS NULL THEN false ELSE true AS is_reversed,
    b.LINKEDLOANTRANSACTIONKEY as linked_loan_transaction_key,
    b.LINKEDSAVINGSTRANSACTIONKEY as linked_savings_transaction_key,
    b.OVERDRAFTAMOUNT as overdraft_amount,
    b.ENTRYDATE as transaction_date
FROM base b
JOIN transaction_details td
    ON b.DETAILS_ENCODEDKEY_OID = td.ENCODEDKEY

