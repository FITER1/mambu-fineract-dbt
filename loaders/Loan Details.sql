INSERT INTO public."Loan Details"(
    savings_account_id, 
    "Maturity Date", 
    created_at, 
    updated_at, 
    "Unified Payments  Total Deductions", 
    "Advance Fee Charged Percentage", 
    "Advance Partner"
)
SELECT 
    m_savings_account.id,
    cf_maturity."VALUE"::date,
    m_savings_account.submittedon_date,
    m_savings_account.submittedon_date,
    cf_unified_payments."VALUE"::numeric(19,2),
    cf_advance_fee."VALUE"::numeric(5,2),
    mc.id
FROM 
    m_savings_account
    -- Joining for "Maturity Date"
    LEFT JOIN customfieldvalue AS cf_maturity ON m_savings_account.external_id = cf_maturity.parentkey AND cf_maturity.customfieldkey = '8a2aba1b44f690cd0144fd1c349626d7'
    -- Joining for "Unified Payments Total Deductions"
    LEFT JOIN customfieldvalue AS cf_unified_payments ON m_savings_account.external_id = cf_unified_payments.parentkey AND cf_unified_payments.customfieldkey = '8a85882c546ba83501547c8f755a3f29'
    -- Joining for "Advance Fee Charged Percentage"
    LEFT JOIN customfieldvalue AS cf_advance_fee ON m_savings_account.external_id = cf_advance_fee.parentkey AND cf_advance_fee.customfieldkey = '8a858ed457e2e6960157e6cdb57f1bf3'
    -- Joining and mapping for "Advance Partner"
    LEFT JOIN customfieldvalue AS cf_advance_partner ON m_savings_account.external_id = cf_advance_partner.parentkey AND cf_advance_partner.customfieldkey = '8a858ed457e2e6960157e6d3617d1d68'
    LEFT JOIN m_code_value mc ON cf_advance_partner."VALUE" = mc.code_value AND mc.code_id = 61
    on conflict(savings_account_id) do nothing;

