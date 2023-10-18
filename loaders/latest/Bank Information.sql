INSERT INTO public."Bank Information" (
    client_id,
    "Account Number",
    "Bank_Name_Clients_cd_Bank Name",
    "bank_account_type_cd_Account Type",
    "BVN",
    "Card Issuing Bank",
    "Card Expiry",
    "Masked Card PAN",
    "Payment Setup URL",
    "Payment Service Provider",
    "Wallet Account ID",
    created_at,
    updated_at,
    "Immediate Withdrawals",
    "Bank Code",
    "Bank Branch"
)
SELECT
    m_client.id,
    cf_account_number."VALUE",
    (SELECT id FROM m_code_value WHERE LOWER(code_value) = LOWER(cf_bank_name."VALUE") AND code_id = 54)::int4,
    (SELECT id FROM m_code_value WHERE LOWER(code_value) = LOWER(cf_account_type."VALUE") AND code_id = 55)::int4,
    cf_bvn."VALUE",
    cf_card_issuing_bank."VALUE",
    cf_card_expiry."VALUE",
    cf_masked_card_pan."VALUE",
    cf_payment_setup_url."VALUE",
    cf_payment_service_provider."VALUE",
    cf_wallet_account_id."VALUE",
    m_client.submittedon_date,
    m_client.submittedon_date,
    CASE WHEN cf_immediate_withdrawals."VALUE" = 'TRUE' THEN 1 ELSE 0 END,
    cf_bank_code."VALUE",
    cf_bank_branch."VALUE"
FROM m_client
LEFT JOIN customfieldvalue cf_account_number ON m_client.external_id = cf_account_number.parentkey AND cf_account_number.customfieldkey = '8a6b840a4202095c0142040f35f148cb'
LEFT JOIN customfieldvalue cf_bank_name ON m_client.external_id = cf_bank_name.parentkey AND cf_bank_name.customfieldkey = '8a6b840a4202095c0142041a86085096'
LEFT JOIN customfieldvalue cf_account_type ON m_client.external_id = cf_account_type.parentkey AND cf_account_type.customfieldkey = '8a1eb5ba49a682300149b332226e4b2c'
LEFT JOIN customfieldvalue cf_bvn ON m_client.external_id = cf_bvn.parentkey AND cf_bvn.customfieldkey = '8a36219649e44d120149e6de472a64dd'
LEFT JOIN customfieldvalue cf_card_issuing_bank ON m_client.external_id = cf_card_issuing_bank.parentkey AND cf_card_issuing_bank.customfieldkey = '8a858f045556eaa4015558c943485621'
LEFT JOIN customfieldvalue cf_card_expiry ON m_client.external_id = cf_card_expiry.parentkey AND cf_card_expiry.customfieldkey = '8a1333885147f287015149bf30223050'
LEFT JOIN customfieldvalue cf_masked_card_pan ON m_client.external_id = cf_masked_card_pan.parentkey AND cf_masked_card_pan.customfieldkey = '8a858e645591c24b0155a07e9688007f'
LEFT JOIN customfieldvalue cf_payment_setup_url ON m_client.external_id = cf_payment_setup_url.parentkey AND cf_payment_setup_url.customfieldkey = '8a858e645591c24b0155a0800ff50100'
LEFT JOIN customfieldvalue cf_payment_service_provider ON m_client.external_id = cf_payment_service_provider.parentkey AND cf_payment_service_provider.customfieldkey = '8a858e645591c24b0155a080fc4c014f'
LEFT JOIN customfieldvalue cf_wallet_account_id ON m_client.external_id = cf_wallet_account_id.parentkey AND cf_wallet_account_id.customfieldkey = '8a858efb675f0bc50167605c286f7f7a'
LEFT JOIN customfieldvalue cf_immediate_withdrawals ON m_client.external_id = cf_immediate_withdrawals.parentkey AND cf_immediate_withdrawals.customfieldkey = '8a81891452d1db190152d4fa93935364'
LEFT JOIN customfieldvalue cf_bank_code ON m_client.external_id = cf_bank_code.parentkey AND cf_bank_code.customfieldkey = '8a25921045fd49cc0145fec1fa7e14fc'
LEFT JOIN customfieldvalue cf_bank_branch ON m_client.external_id = cf_bank_branch.parentkey AND cf_bank_branch.customfieldkey = '8a6b840a4202095c0142040efbe64896'
on conflict(client_id) do nothing;
