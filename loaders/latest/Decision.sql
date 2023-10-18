INSERT INTO public."Decision"(
    loan_id, 
    "Decision System", 
    "Decision Reason", 
    created_at, 
    updated_at
)
SELECT 
    m_loan.id,
    cf_decision_system."VALUE"::text,
    cf_decision_reason."VALUE"::text,
    m_loan.submittedon_date,
    m_loan.submittedon_date
FROM 
    m_loan
    -- Joining for "Decision System"
    LEFT JOIN customfieldvalue AS cf_decision_system ON m_loan.external_id = cf_decision_system.parentkey AND cf_decision_system.customfieldkey = '8a13283e4f2be513014f45415cd65805'
    -- Joining for "Decision Reason"
    LEFT JOIN customfieldvalue AS cf_decision_reason ON m_loan.external_id = cf_decision_reason.parentkey AND cf_decision_reason.customfieldkey = '8a29909e4f2c187d014f2c445be60764'
    on conflict (loan_id) do nothing;

