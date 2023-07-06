INSERT INTO public.m_product_loan(
	short_name, currency_code, currency_digits, currency_multiplesof, principal_amount, min_principal_amount, max_principal_amount, arrearstolerance_amount, name, description, fund_id, is_linked_to_floating_interest_rates, allow_variabe_installments, nominal_interest_rate_per_period, min_nominal_interest_rate_per_period, max_nominal_interest_rate_per_period, interest_period_frequency_enum, annual_nominal_interest_rate, interest_method_enum, interest_calculated_in_period_enum, allow_partial_period_interest_calcualtion, repay_every, repayment_period_frequency_enum, number_of_repayments, min_number_of_repayments, max_number_of_repayments, grace_on_principal_periods, recurring_moratorium_principal_periods, grace_on_interest_periods, grace_interest_free_periods, amortization_method_enum, accounting_type, loan_transaction_strategy_id, external_id, include_in_borrower_cycle, use_borrower_cycle, start_date, close_date, allow_multiple_disbursals, max_disbursals, max_outstanding_loan_balance, grace_on_arrears_ageing, overdue_days_for_npa, days_in_month_enum, days_in_year_enum, interest_recalculation_enabled, min_days_between_disbursal_and_first_repayment, hold_guarantee_funds, principal_threshold_for_last_installment, account_moves_out_of_npa_only_on_arrears_completion, can_define_fixed_emi_amount, instalment_amount_in_multiples_of, can_use_for_topup, sync_expected_with_disbursement_date, is_equal_amortization, fixed_principal_percentage_per_installment, disallow_expected_disbursements, allow_approved_disbursed_amounts_over_applied, over_applied_calculation_type, over_applied_number, is_loan_term_includes_topped_up_loan_term, max_number_of_loan_extensions_allowed, is_account_level_arrears_tolerance_enable, is_bnpl_loan_product, requires_equity_contribution, equity_contribution_loan_percentage, product_category_id, product_type_id)
	SELECT SUBSTRING(gen_random_uuid()::text, 0, 4), currency_code, currency_digits, currency_multiplesof, principal_amount, min_principal_amount, max_principal_amount, arrearstolerance_amount, name, description, fund_id, is_linked_to_floating_interest_rates, allow_variabe_installments, nominal_interest_rate_per_period, min_nominal_interest_rate_per_period, max_nominal_interest_rate_per_period, interest_period_frequency_enum, annual_nominal_interest_rate, interest_method_enum, interest_calculated_in_period_enum, allow_partial_period_interest_calcualtion, repay_every, repayment_period_frequency_enum, number_of_repayments, min_number_of_repayments, max_number_of_repayments, grace_on_principal_periods, recurring_moratorium_principal_periods, grace_on_interest_periods, grace_interest_free_periods, amortization_method_enum, accounting_type, loan_transaction_strategy_id, external_id, include_in_borrower_cycle, use_borrower_cycle, start_date, close_date, allow_multiple_disbursals, max_disbursals, max_outstanding_loan_balance, grace_on_arrears_ageing, overdue_days_for_npa, days_in_month_enum, days_in_year_enum, interest_recalculation_enabled, min_days_between_disbursal_and_first_repayment, hold_guarantee_funds, principal_threshold_for_last_installment, account_moves_out_of_npa_only_on_arrears_completion, can_define_fixed_emi_amount, instalment_amount_in_multiples_of, can_use_for_topup, sync_expected_with_disbursement_date, is_equal_amortization, fixed_principal_percentage_per_installment, disallow_expected_disbursements, allow_approved_disbursed_amounts_over_applied, over_applied_calculation_type, over_applied_number, is_loan_term_includes_topped_up_loan_term, max_number_of_loan_extensions_allowed, is_account_level_arrears_tolerance_enable, is_bnpl_loan_product, requires_equity_contribution, equity_contribution_loan_percentage, product_category_id, product_type_id
	FROM m_product_loan_view;

INSERT INTO m_product_loan_configurable_attributes (loan_product_id)
SELECT id FROM m_product_loan WHERE id NOT IN (SELECT loan_product_id from m_product_loan_configurable_attributes);

UPDATE m_product_loan SET accounting_type = 1 WHERE accounting_type = 3;

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
