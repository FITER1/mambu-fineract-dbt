INSERT INTO public.m_savings_product(
	name, short_name, description, deposit_type_enum, currency_code, currency_digits, currency_multiplesof, nominal_annual_interest_rate, interest_compounding_period_enum, interest_posting_period_enum, interest_calculation_type_enum, interest_calculation_days_in_year_type_enum, min_required_opening_balance, lockin_period_frequency, lockin_period_frequency_enum, accounting_type, withdrawal_fee_amount, withdrawal_fee_type_enum, withdrawal_fee_for_transfer, allow_overdraft, overdraft_limit, nominal_annual_interest_rate_overdraft, min_overdraft_for_interest_calculation, min_required_balance, enforce_min_required_balance, min_balance_for_interest_calculation, withhold_tax, tax_group_id, is_dormancy_tracking_active, days_to_inactive, days_to_dormancy, days_to_escheat, max_allowed_lien_limit, is_lien_allowed, is_interest_posting_config_update, num_of_credit_transaction, num_of_debit_transaction, is_usd_product, allow_manually_enter_interest_rate, add_penalty_on_missed_target_savings, use_floating_interest_rate, withdrawal_frequency, withdrawal_frequency_enum, product_category_id, product_type_id, post_overdraft_interest_on_deposit)
	SELECT name, SUBSTRING(gen_random_uuid()::text, 0, 4), description, deposit_type_enum, currency_code, currency_digits, currency_multiplesof, COALESCE(nominal_annual_interest_rate, 0), interest_compounding_period_enum, interest_posting_period_enum, interest_calculation_type_enum, interest_calculation_days_in_year_type_enum, min_required_opening_balance, lockin_period_frequency, lockin_period_frequency_enum, accounting_type, withdrawal_fee_amount, withdrawal_fee_type_enum, withdrawal_fee_for_transfer, allow_overdraft, overdraft_limit, nominal_annual_interest_rate_overdraft, min_overdraft_for_interest_calculation, min_required_balance, enforce_min_required_balance, min_balance_for_interest_calculation, withhold_tax, tax_group_id, is_dormancy_tracking_active, days_to_inactive, days_to_dormancy, days_to_escheat, max_allowed_lien_limit, is_lien_allowed, is_interest_posting_config_update, num_of_credit_transaction, num_of_debit_transaction, is_usd_product, allow_manually_enter_interest_rate, add_penalty_on_missed_target_savings, use_floating_interest_rate, withdrawal_frequency, withdrawal_frequency_enum, product_category_id, product_type_id, post_overdraft_interest_on_deposit
FROM m_savings_product_view;

UPDATE m_savings_product SET accounting_type = 1 WHERE accounting_type = 3;

UPDATE m_savings_product SET withhold_tax = false;

INSERT INTO m_deposit_product_term_and_preclosure (savings_product_id, min_deposit_term, max_deposit_term,
												  min_deposit_term_type_enum, max_deposit_term_type_enum,
												  pre_closure_penal_applicable, min_deposit_amount, max_deposit_amount,
												  deposit_amount)
SELECT msp.id, sp.minmaturityperiod, sp.maxmaturityperiod,
CASE
	WHEN sp.maturityperiodunit = 'MONTHS' THEN 2
	WHEN sp.maturityperiodunit = 'DAYS' THEN 0
	WHEN sp.maturityperiodunit = 'WEEKS' THEN 1
	WHEN sp.maturityperiodunit = 'YEARS' THEN 3
	ELSE NULL
END AS min_deposit_term_type_enum,
CASE
	WHEN sp.maturityperiodunit = 'MONTHS' THEN 2
	WHEN sp.maturityperiodunit = 'DAYS' THEN 0
	WHEN sp.maturityperiodunit = 'WEEKS' THEN 1
	WHEN sp.maturityperiodunit = 'YEARS' THEN 3
	ELSE NULL
END AS max_deposit_term_type_enum,
false pre_closure_penal_applicable,
sp.minopeningbalance, sp.maxopeningbalance, sp.minopeningbalance
FROM m_savings_product msp
JOIN savingsproduct sp ON msp.description = sp.encodedkey
WHERE id NOT IN (SELECT savings_product_id FROM m_deposit_product_term_and_preclosure)
AND deposit_type_enum = 200;