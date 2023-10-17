INSERT INTO public."Payvest Details" (
    savings_account_id,
    "Investment Tenor in Days",
    "Liquidation Payout Status_cd_Liquidation Payout Status",
    "Liquidation Requested",
    "Effective Interest Rate Percentage",
    "investment_liquidation_dest_cd_Investment Liquidation Destinati",
    "investment_tenor_unit_cd_Unit of Investment Tenor",
    "Value of Investment Tenor",
    "Investment Lock Status",
    "Recurring Investment Amount",
    "Investment Pause Status",
    "investment_topup_frequency_cd_Investment Topup Frequency",
    "Early Liquidation",
    created_at,
    updated_at
)
SELECT
    msa.id AS savings_account_id,
    cf1."VALUE"::int AS "Investment Tenor in Days",
    (SELECT id FROM m_code_value WHERE code_value = cf2."VALUE" AND code_id = 63) AS "Liquidation Payout Status_cd_Liquidation Payout Status",
    CASE WHEN cf3."VALUE"= 'TRUE' THEN '1'::bit ELSE '0'::bit END AS "Liquidation Requested",
    cf4."VALUE"::decimal(5,2) AS "Effective Interest Rate Percentage",
    (SELECT id FROM m_code_value WHERE code_value = cf5."VALUE" AND code_id = 82) AS "investment_liquidation_dest_cd_Investment Liquidation Destinati",
    (SELECT id FROM m_code_value WHERE code_value = cf6."VALUE" AND code_id = 64) AS "investment_tenor_unit_cd_Unit of Investment Tenor",
    cf7."VALUE"::int AS "Value of Investment Tenor",
    CASE WHEN cf8."VALUE"= 'TRUE' THEN '1'::bit ELSE '0'::bit END AS "Investment Lock Status",
    cf9."VALUE"::decimal(19,2) AS "Recurring Investment Amount",
    CASE WHEN cf10."VALUE"= 'TRUE' THEN '1'::bit ELSE '0'::bit END AS "Investment Pause Status",
    (SELECT id FROM m_code_value WHERE code_value = cf11."VALUE" AND code_id = 65) AS "investment_topup_frequency_cd_Investment Topup Frequency",
    CASE WHEN cf12."VALUE"= 'TRUE' THEN '1'::bit ELSE '0'::bit END AS "Early Liquidation",
    msa.submittedon_date AS created_at,
    msa.submittedon_date AS updated_at
FROM
    m_savings_account msa
LEFT JOIN customfieldvalue cf1 ON msa.external_id = cf1.parentkey AND cf1.customfieldkey = '8a858ffc644738f501644862916c4765'
LEFT JOIN customfieldvalue cf2 ON msa.external_id = cf2.parentkey AND cf2.customfieldkey = '8a858ffc644738f501644866c29347cf'
LEFT JOIN customfieldvalue cf3 ON msa.external_id = cf3.parentkey AND cf3.customfieldkey = '8a858ffc644738f50164486858a347fd'
LEFT JOIN customfieldvalue cf4 ON msa.external_id = cf4.parentkey AND cf4.customfieldkey = '8a858f8a6454a1e601645b3fcca24b84'
LEFT JOIN customfieldvalue cf5 ON msa.external_id = cf5.parentkey AND cf5.customfieldkey = '8a858ebd6762b70f0167659fccf804b9'
LEFT JOIN customfieldvalue cf6 ON msa.external_id = cf6.parentkey AND cf6.customfieldkey = '8a858f0a6cb8329d016cb8b2dbf03285'
LEFT JOIN customfieldvalue cf7 ON msa.external_id = cf7.parentkey AND cf7.customfieldkey = '8a858f0a6cb8329d016cb8b54343333d'
LEFT JOIN customfieldvalue cf8 ON msa.external_id = cf8.parentkey AND cf8.customfieldkey = '8a858f0a6cb8329d016cb8b6433c338e'
LEFT JOIN customfieldvalue cf9 ON msa.external_id = cf9.parentkey AND cf9.customfieldkey = '8a858f0a6cb8329d016cb8bb7dfb3541'
LEFT JOIN customfieldvalue cf10 ON msa.external_id = cf10.parentkey AND cf10.customfieldkey = '8a858f0a6cb8329d016cb8be242d3661'
LEFT JOIN customfieldvalue cf11 ON msa.external_id = cf11.parentkey AND cf11.customfieldkey = '8a858f0a6cb8329d016cb8bf90c436c7'
LEFT JOIN customfieldvalue cf12 ON msa.external_id = cf12.parentkey AND cf12.customfieldkey = '8a858fce84ee4cc30184f1618cec0087'
on conflict(savings_account_id) do nothing;
