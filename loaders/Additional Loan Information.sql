INSERT INTO public."Additional Loan Information" (
    loan_id,
    "Loan Reapplied",
    "Loan Closed At Migration",
    "Top Up Loan",
    "Is Carbon Zero Loan",
    "Referral Client ID",
    "Repayment Start Date",
    "Repayment End Date",
    "Disbursed Amount",
    "Disbursement Status_cd_Disbursement Status",
    "Loan Channel",
    "Device ID",
    "Rebate Code",
    "Rebate Amount",
    "Application ID",
    "Desired Amount",
    "Delay Reason",
    "Loan Cashback Amount",
    "Loan Cashback Percentage",
    "Disbursement Channel Key",
    "Merchant ID",
    "Purchase Reference ID",
    "Merchant Account Number",
    "Merchant Bank Code",
    created_at,
    updated_at
)
SELECT
    m_loan.id,
    CASE WHEN cf1."VALUE"= 'TRUE' THEN '1'::bit ELSE '0'::bit END,
    CASE WHEN cf2."VALUE"= 'TRUE' THEN '1'::bit ELSE '0'::bit END,
    CASE WHEN cf3."VALUE"= 'TRUE' THEN '1'::bit ELSE '0'::bit END,
    CASE WHEN cf4."VALUE"= 'TRUE' THEN '1'::bit ELSE '0'::bit END,
    cf5."VALUE",
    cf6."VALUE"::date,
    cf7."VALUE"::date,
    REPLACE(cf8."VALUE", ',', '')::numeric(19,2),
    mcv.id,
    cf10."VALUE",
    cf11."VALUE",
    cf12."VALUE",
    REPLACE(cf13."VALUE", ',', '')::numeric(19,2),
    cf14."VALUE",
    REPLACE(cf15."VALUE", ',', '')::numeric(19,2),
    cf16."VALUE",
    REPLACE(cf17."VALUE", ',', '')::numeric(19,2),
    REPLACE(cf18."VALUE", ',', '')::numeric(5,2),
    cf19."VALUE",
    cf20."VALUE",
    cf21."VALUE",
    cf22."VALUE",
    cf23."VALUE",
    m_loan.submittedon_date,
    m_loan.submittedon_date
FROM m_loan
LEFT JOIN customfieldvalue cf1 ON cf1.parentkey = m_loan.external_id AND cf1.customfieldkey = '8a6b840a4202095c01420412a1d44ac9'
LEFT JOIN customfieldvalue cf2 ON cf2.parentkey = m_loan.external_id AND cf2.customfieldkey = '8af82d3f42103a7a014212ecd7e72237'
LEFT JOIN customfieldvalue cf3 ON cf3.parentkey = m_loan.external_id AND cf3.customfieldkey = '8a858fe55511cbce01551744b99d3b25'
LEFT JOIN customfieldvalue cf4 ON cf4.parentkey = m_loan.external_id AND cf4.customfieldkey = '8a858ffe8683c74401868aca630f43fd'
LEFT JOIN customfieldvalue cf5 ON cf5.parentkey = m_loan.external_id AND cf5.customfieldkey = '8a858fc959bc56c80159cb06ee767018'
LEFT JOIN customfieldvalue cf6 ON cf6.parentkey = m_loan.external_id AND cf6.customfieldkey = '8a2898ea4467f87b014469c180447364'
LEFT JOIN customfieldvalue cf7 ON cf7.parentkey = m_loan.external_id AND cf7.customfieldkey = '8a2898ea4467f87b014469c20b2073f8'
LEFT JOIN customfieldvalue cf8 ON cf8.parentkey = m_loan.external_id AND cf8.customfieldkey = '8a362e6b44cebb590144d5ab865f028c'
LEFT JOIN customfieldvalue cf9 ON cf9.parentkey = m_loan.external_id AND cf9.customfieldkey = '8a858e845800dfc001580712758c157b'
LEFT JOIN customfieldvalue cf10 ON cf10.parentkey = m_loan.external_id AND cf10.customfieldkey = '8a85892854be331a0154c3fcf9ee6aee'
LEFT JOIN customfieldvalue cf11 ON cf11.parentkey = m_loan.external_id AND cf11.customfieldkey = '8a858f1554e294490154f1c2fc040b3f'
LEFT JOIN customfieldvalue cf12 ON cf12.parentkey = m_loan.external_id AND cf12.customfieldkey = '8a858f0e5a6171ba015a66adb57d1132'
LEFT JOIN customfieldvalue cf13 ON cf13.parentkey = m_loan.external_id AND cf13.customfieldkey = '8a858f0e5a6171ba015a66aed66e1178'
LEFT JOIN customfieldvalue cf14 ON cf14.parentkey = m_loan.external_id AND cf14.customfieldkey = '8a858f9f5dd14307015ddb6f8d9029e1'
LEFT JOIN customfieldvalue cf15 ON cf15.parentkey = m_loan.external_id AND cf15.customfieldkey = '8a858f9f5dd14307015ddb714b212a66'
LEFT JOIN customfieldvalue cf16 ON cf16.parentkey = m_loan.external_id AND cf16.customfieldkey = '8a858f926b715531016b715d74f101d3'
LEFT JOIN customfieldvalue cf17 ON cf17.parentkey = m_loan.external_id AND cf17.customfieldkey = '8a858eb36cf61a27016cf7a4ef21141b'
LEFT JOIN customfieldvalue cf18 ON cf18.parentkey = m_loan.external_id AND cf18.customfieldkey = '8a858eb36cf61a27016cf7a5d857146c'
LEFT JOIN customfieldvalue cf19 ON cf19.parentkey = m_loan.external_id AND cf19.customfieldkey = '8a858f3a6d90af22016d930c92186924'
LEFT JOIN customfieldvalue cf20 ON cf20.parentkey = m_loan.external_id AND cf20.customfieldkey = '8a858ee88442731f01844e5cc0617c44'
LEFT JOIN customfieldvalue cf21 ON cf21.parentkey = m_loan.external_id AND cf21.customfieldkey = '8a858ee88442731f01844e5e01aa7c9a'
LEFT JOIN customfieldvalue cf22 ON cf22.parentkey = m_loan.external_id AND cf22.customfieldkey = '8a858ffe8683c74401868ac9054942c1'
LEFT JOIN customfieldvalue cf23 ON cf23.parentkey = m_loan.external_id AND cf23.customfieldkey = '8a858ffe8683c74401868ac993e6430b'
LEFT JOIN m_code_value mcv ON mcv.code_value = cf9."VALUE" AND mcv.code_id = 58
WHERE m_loan.id IS NOT NULL
on conflict (loan_id) do nothing;