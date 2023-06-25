{{ config(materialized='table') }}

WITH base AS (
    SELECT *,
        encodedkey as external_id,
        ABS(amount) as transaction_amount,
        balance as running_balance,
        "COMMENT" AS transaction_notes,
        DETAILS_ENCODEDKEY_OID as details_external_id,
        PARENTACCOUNTKEY as account_external_id,
        CREATIONDATE as creation_date,
        "TYPE" as transaction_type,
        REVERSALTRANSACTIONKEY as reversal_transaction_key,
        LINKEDLOANTRANSACTIONKEY as linked_loan_transaction_key,
        LINKEDSAVINGSTRANSACTIONKEY as linked_savings_transaction_key,
        OVERDRAFTAMOUNT as overdraft_amount,
        ENTRYDATE as transaction_date
    FROM {{ ref('final_wallet_transaction') }}
),

transaction_details AS (
    SELECT *
    FROM transactiondetails
)

SELECT
    ROW_NUMBER() OVER () as id,
    b.external_id,
    b.transaction_amount,
    b.running_balance,
    b.account_external_id,
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
    b.transaction_notes,
    td.TRANSACTIONCHANNELKEY as transaction_channel_key,
    b.creation_date,
    CASE WHEN b.reversal_transaction_key IS NULL THEN false ELSE true END AS is_reversed,
    b.linked_loan_transaction_key,
    b.linked_savings_transaction_key,
    b.overdraft_amount,
    b.transaction_date
FROM base b
LEFT JOIN transaction_details td
    ON b.details_external_id = td.ENCODEDKEY

