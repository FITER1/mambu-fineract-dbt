{{ config(materialized='table') }}

WITH decoded_repayment AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY ENCODEDKEY)+(SELECT MAX(id) FROM "public"."m_loan_repayment_schedule") as id,
        "parentaccountkey" AS parentaccountkey,
        -- CREATIONDATE as fromdate,
        NULL as fromdate,
        DUEDATE as duedate,
        PRINCIPALDUE as principal_amount,
        PRINCIPALPAID as principal_completed_derived,
        INTERESTDUE as interest_amount,
        INTERESTPAID as interest_completed_derived,
        LASTPAIDDATE as last_paid_date,
        LASTPENALTYAPPLIEDDATE as last_penalty_applied_date,
        REPAIDDATE as repaid_date,
        NULL as state,
        FEESDUE as fees_due,
        FEESPAID as fees_paid,
        PENALTYDUE as penalty_due,
        PENALTYPAID as penalty_paid
    FROM {{ ref('repayment') }}
),
mv_loan AS (
    SELECT id,external_id,account_no
    FROM {{ ref('m_loan_view') }}

    UNION 

    SELECT id,external_id,account_no
    FROM m_loan
),
repayment_with_loan_id AS (
    SELECT 
        dr.id,
        mv_loan.id AS loan_id,
        dr.fromdate,
        dr.duedate,
        dr.principal_amount,
        dr.principal_completed_derived,
        dr.interest_amount,
        dr.interest_completed_derived,
        dr.parentaccountkey as loan_external_id,
        dr.last_paid_date,
        dr.last_penalty_applied_date,
        dr.repaid_date,
        dr.state,
        dr.fees_due,
        dr.fees_paid,
        dr.penalty_due,
        dr.penalty_paid
    FROM decoded_repayment AS dr
    LEFT JOIN  mv_loan ON dr.parentaccountkey = mv_loan.external_id
    WHERE CHAR_LENGTH(mv_loan.account_no) <= 20
)

SELECT * FROM repayment_with_loan_id
