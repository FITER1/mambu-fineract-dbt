
UPDATE m_loan SET expected_disbursedon_date = disbursementdetails.disbursementdate,
disbursedon_date = disbursementdetails.disbursementdate
FROM final_loanaccount
JOIN disbursementdetails ON final_loanaccount.disbursementdetailskey = disbursementdetails.encodedkey
WHERE m_loan.external_id = final_loanaccount.encodedkey
AND m_loan.disbursedon_date IS NULL;



insert into temp_saving_account
(
WITH base AS (
    SELECT 
        encodedkey as external_id,
        WITHHOLDINGTAXSOURCEKEY as withholding_tax_source_key,
        INTERESTSETTINGSKEY as interest_settings_key,
        OVERDRAFTINTERESTSETTINGSKEY as overdraft_interest_settings_key
    FROM final_wallet
),
interest_settings AS (
    SELECT *
    FROM interestaccountsettings
)
SELECT 
    external_id,
    overdraft_interest_settings_key,
    interest_settings_key,
    withholding_tax_source_key,
    CASE
        WHEN ir.RATE IS NOT NULL THEN true
        ELSE false
    END as withhold_tax,
    oist.interestrate as nominal_annual_interest_rate_overdraft,
    ist.interestrate
FROM base b
LEFT JOIN interest_settings ist ON b.interest_settings_key = ist.encodedkey
LEFT JOIN interest_settings oist ON b.overdraft_interest_settings_key = oist.encodedkey
LEFT JOIN indexratesource irs ON b.withholding_tax_source_key = irs.encodedkey
LEFT JOIN indexrate ir ON ir.INDEXINTERESTRATESOURCE_ENCODEDKEY_OID = irs.encodedkey);



insert into temp_saving_account
(
WITH base AS (
    SELECT 
        encodedkey as external_id,
        WITHHOLDINGTAXSOURCEKEY as withholding_tax_source_key,
        INTERESTSETTINGSKEY as interest_settings_key,
        OVERDRAFTINTERESTSETTINGSKEY as overdraft_interest_settings_key
    FROM final_investment 
),
interest_settings AS (
    SELECT *
    FROM interestaccountsettings
)
SELECT 
    external_id,
    overdraft_interest_settings_key,
    interest_settings_key,
    withholding_tax_source_key,
    CASE
        WHEN ir.RATE IS NOT NULL THEN true
        ELSE false
    END as withhold_tax,
    oist.interestrate as nominal_annual_interest_rate_overdraft,
    ist.interestrate
FROM base b
LEFT JOIN interest_settings ist ON b.interest_settings_key = ist.encodedkey
LEFT JOIN interest_settings oist ON b.overdraft_interest_settings_key = oist.encodedkey
LEFT JOIN indexratesource irs ON b.withholding_tax_source_key = irs.encodedkey
LEFT JOIN indexrate ir ON ir.INDEXINTERESTRATESOURCE_ENCODEDKEY_OID = irs.encodedkey);







UPDATE m_savings_account sa
SET 
    nominal_annual_interest_rate = COALESCE(ts.interestrate, 0), 
    withhold_tax = ts.withhold_tax, 
    nominal_annual_interest_rate_overdraft = COALESCE(ts.nominal_annual_interest_rate_overdraft, 0)
FROM temp_saving_account ts
WHERE sa.external_id = ts.external_id;