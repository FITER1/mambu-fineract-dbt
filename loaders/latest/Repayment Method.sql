INSERT INTO public."Repayment Method" (
    loan_id, 
    "Post Dated Cheques Loan Accounts",
    "Direct Debit Mandate Loan Accounts",
    "Deductions from Source Loan Accounts",
    "Electronic Direct Debit Mandate",
    "Repayment Plan_cd_Repayment Plan",
    "Repayment Plan Amount",
    created_at,
    updated_at
)
SELECT 
    m_loan.id AS loan_id,
    CASE WHEN (cf1."VALUE"::boolean IS TRUE) THEN '1'::bit  ELSE '0'::bit END AS "Post Dated Cheques Loan Accounts",
    CASE WHEN (cf2."VALUE"::boolean IS TRUE) THEN '1'::bit  ELSE '0'::bit END AS "Direct Debit Mandate Loan Accounts",
    CASE WHEN (cf3."VALUE"::boolean IS TRUE) THEN '1'::bit  ELSE '0'::bit END AS "Deductions from Source Loan Accounts",
    CASE WHEN (cf4."VALUE"::boolean IS TRUE) THEN '1'::bit  ELSE '0'::bit END AS "Electronic Direct Debit Mandate",
    cv.id AS "Repayment Plan_cd_Repayment Plan",
    cf5."VALUE"::decimal(19,2) AS "Repayment Plan Amount",
    m_loan.submittedon_date AS created_at,
    m_loan.submittedon_date AS updated_at
FROM 
    m_loan
JOIN customfieldvalue cf1 ON m_loan.external_id = cf1.parentkey AND cf1.customfieldkey = '8a5ced2443e0bf990143e306bc3a2eea'
JOIN customfieldvalue cf2 ON m_loan.external_id = cf2.parentkey AND cf2.customfieldkey = '8a5ced2443e0bf990143e30876862f71'
JOIN customfieldvalue cf3 ON m_loan.external_id = cf3.parentkey AND cf3.customfieldkey = '8a1a21b24e550721014e6285bc9c7985'
JOIN customfieldvalue cf4 ON m_loan.external_id = cf4.parentkey AND cf4.customfieldkey = '8a858e645591c24b0155a085194302c7'
JOIN customfieldvalue cf5 ON m_loan.external_id = cf5.parentkey AND cf5.customfieldkey = '8a858f946ab6720e016ab6825c5603a4'
LEFT JOIN m_code_value cv ON cf5."VALUE" = cv.code_value AND cv.code_id = 59
on conflict (loan_id) do nothing;
