INSERT INTO public."Paylater Information" (loan_id, "Pre Approved Credit Limit", "Source_cd_Source", created_at, updated_at)
SELECT
    m_loan.id AS loan_id,
    CF1."VALUE"::numeric(19, 2) AS "Pre Approved Credit Limit",
    CV.id AS "Source_cd_Source",
    m_loan.submittedon_date AS created_at,
    m_loan.submittedon_date AS updated_at
FROM m_loan
-- Join for "Pre Approved Credit Limit"
LEFT JOIN customfieldvalue AS CF1
ON m_loan.external_id = CF1.parentkey
AND CF1.customfieldkey = '8a6a96044539adf801453cee8f897aac'
-- Join for "Source_cd_Source"
LEFT JOIN customfieldvalue AS CF2
ON m_loan.external_id = CF2.parentkey
AND CF2.customfieldkey = '8a6a96044539adf801453cfed831035c'
LEFT JOIN m_code_value AS CV
ON CF2."VALUE" = CV.code_value AND CV.code_id = 88
on conflict (loan_id) do nothing;
