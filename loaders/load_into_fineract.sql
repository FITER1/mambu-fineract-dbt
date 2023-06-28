--m_role
INSERT INTO m_role (name, description, is_disabled) SELECT name, description, is_disabled FROM m_role_view;
--m_role end

--m_office
INSERT INTO m_office SELECT * FROM m_office_view;
--m_office end
--m_staff
ALTER TABLE m_staff
DROP CONSTRAINT m_staff_mobile_no_key;

INSERT INTO m_staff SELECT * FROM m_staff_view;
-- m_staff end

-- reinstate constraint
UPDATE m_staff SET mobile_no = NULL where mobile_no = '';

ALTER TABLE m_staff
ADD CONSTRAINT m_staff_mobile_no_key UNIQUE (mobile_no);

-- m_appuser

INSERT INTO m_appuser SELECT * FROM m_appuser_view WHERE username NOT IN (SELECT username FROM m_appuser) AND id > 40;

-- align staff office_id
UPDATE m_staff SET office_id = m_appuser.office_id
FROM m_appuser
WHERE m_staff.id = m_appuser.staff_id;
--m_appuser end

--m_client
ALTER TABLE m_client
DROP CONSTRAINT m_client_mobile_no_key;

INSERT INTO m_client (account_no, external_id, status_enum, firstname, middlename, lastname, display_name, mobile_no, office_id, date_of_birth, submittedon_date, activation_date, closedon_date)
SELECT
    account_no,
    external_id,
    status_enum,
    firstname,
    middlename,
    lastname,
    firstname || ' ' || middlename || ' ' || lastname AS display_name, -- concatenate firstname and lastname
    mobile_no,
    COALESCE((SELECT id FROM m_office WHERE external_id = cv.office_external_id), 1) as office_id,
    date_of_birth::date,
    submittedon_date::date,
    activation_date::date,
    closedon_date::date
FROM m_client_view cv
WHERE account_no NOT IN (SELECT account_no FROM m_client);

-- ALTER SEQUENCE m_client_id_seq RESTART WITH 22606;
-- update status_enum
UPDATE m_client SET status_enum = m_client_view.status_enum
FROM m_client_view
WHERE m_client_view.external_id = m_client.external_id;

UPDATE m_client SET legal_form_enum = 1;
-- m_client end

-- m_group
INSERT INTO public.m_group (
    id,
    external_id,
    status_enum,
    office_id,
    staff_id,
    display_name,
    submittedon_date,
    account_no,
    level_id
)
SELECT
    DISTINCT id,
    external_id,
    status_enum,
    office_id,
    staff_id,
    display_name,
    submittedon_date::date, 
    account_no,
    level_id
FROM
    public.m_group_view
WHERE
    CHAR_LENGTH(account_no) <= 20
    AND id NOT IN (SELECT id FROM m_group)
    AND display_name NOT LIKE '%test%'
    AND display_name NOT LIKE '%Test%'
    AND display_name NOT IN ('Carbon (Agents)','Yemi Alade - TECO', 'Scissors Mgbai - TECO');

--m_group end

 --- m_loan

 INSERT INTO public.m_loan (
    account_no, 
    external_id, 
    client_id, 
    group_id,
    product_id,
    loan_type_enum, 
    interest_method_enum, 
    principal_amount, 
    approvedon_date, 
    expected_firstrepaymenton_date, 
    repayment_period_frequency_enum, 
    repay_every, 
    term_period_frequency_enum, 
    loan_status_id, 
    loan_sub_status_id, 
    interest_period_frequency_enum, 
    interest_outstanding_derived, 
    interest_repaid_derived, 
    nominal_interest_rate_per_period, 
    interest_charged_derived, 
    fee_charges_charged_derived, 
    fee_charges_repaid_derived,
    created_on_utc,
    created_by,
    currency_code,
    currency_digits,
    principal_amount_proposed,
    approved_principal,
    net_disbursal_amount,
    number_of_repayments,
    amortization_method_enum,
    last_modified_on_utc
)
SELECT
    account_no, 
    external_id, 
    (SELECT id FROM m_client WHERE external_id = lv.client_external_id) client_id, 
    (SELECT id FROM m_group WHERE external_id = lv.group_external_id) group_id,
    (SELECT id FROM m_product_loan WHERE external_id = lv.product_id) product_id,
    loan_type_enum, 
    interest_method_enum, 
    principal_amount, 
    approvedon_date, 
    TO_TIMESTAMP(expected_firstrepaymenton_date), 
    repayment_period_frequency_enum, 
    repay_every, 
    term_period_frequency_enum, 
    loan_status_id, 
    loan_sub_status_id, 
    interest_period_frequency_enum, 
    interest_outstanding_derived, 
    interest_repaid_derived, 
    nominal_interest_rate_per_period, 
    interest_charged_derived, 
    fee_charges_charged_derived, 
    fee_charges_repaid_derived,
    created_on_utc,
    1,
    'USD',
    2,
    CAST(principal_amount AS numeric(19, 6)), -- Assuming proposed principal amount is same as principal amount
    CAST(principal_amount AS numeric(19, 6)), -- Assuming approved principal amount is same as principal amount
    CAST(principal_amount AS numeric(19, 6)), -- Assuming net disbursal amount is same as principal amount
    number_of_repayments,
    1,
    last_modified_on_utc
FROM public.m_loan_view lv
WHERE (client_id IS NOT NULL)
AND external_id NOT IN (SELECT external_id FROM m_loan WHERE external_id IS NOT NULL)
AND id > 125 AND id NOT IN (507, 508, 509, 511, 513, 514);


UPDATE m_loan SET expected_disbursedon_date = disbursementdetails.disbursementdate,
disbursedon_date = disbursementdetails.disbursementdate
FROM final_loanaccount
JOIN disbursementdetails ON final_loanaccount.disbursementdetailskey = disbursementdetails.encodedkey
WHERE m_loan.external_id = final_loanaccount.encodedkey;

 -- m_loan end       

-- m_document 
INSERT INTO public.m_document 
(parent_entity_type, parent_entity_id, "name", file_name, "size", "type", description, "location", storage_type_enum)
SELECT 
    -- Parent Entity Type is unknown from view, so we put a placeholder value
    'unknown' AS parent_entity_type,
    -- Parent Entity ID is unknown from view, so we put a placeholder value
    0 AS parent_entity_id,
    name,
    file_name,
    size,
    type,
    description,
    location,
    -- Storage type enum is unknown from view, so we put a placeholder value
    NULL AS storage_type_enum
FROM public.m_document_view;
-- m_document ends




-- m_loan_transaction
INSERT INTO public.m_loan_transaction (
    external_id, 
    amount, 
    outstanding_loan_balance_derived, 
    office_id, 
    created_date, 
    loan_id, 
    transaction_type_enum, 
    transaction_date, 
    principal_portion_derived, 
    interest_portion_derived, 
    fee_charges_portion_derived, 
    penalty_charges_portion_derived,
    submitted_on_date,
    is_reversed
)
SELECT tmp.* FROM (
SELECT 
    ltv.external_id, 
    ltv.amount, 
    ltv.outstanding_loan_balance_derived, 
    1, 
    ltv.created_date, 
    (SELECT id FROM m_loan WHERE external_id = ltv.loan_external_id) loan_id, 
    ltv.transaction_type_enum, 
    ltv.transaction_date, 
    ltv.principal_portion_derived, 
    ltv.interest_portion_derived, 
    ltv.fee_charges_portion_derived, 
    ltv.penalty_charges_portion_derived,
    ltv.created_date,
    FALSE
FROM m_loan_transaction_view ltv LEFT JOIN m_loan_transaction lt
ON ltv.external_id = lt.external_id
WHERE lt.id IS NULL
) tmp WHERE tmp.loan_id IS NOT NULL;

UPDATE m_loan_transaction
SET office_id = m_client.office_id
FROM m_loan
JOIN m_client ON m_client.id = m_loan.client_id
WHERE m_loan_transaction.loan_id = m_loan.id;

-- m_loan_transaction end

-- m_loan_repayment 
INSERT INTO public.m_loan_repayment_schedule (
    loan_id, 
    fromdate, 
    duedate, 
    installment, 
    principal_amount, 
    principal_completed_derived, 
    interest_amount, 
    interest_completed_derived, 
    completed_derived, 
    recalculated_interest_component
)
SELECT 
    CAST(loan_id AS int8),
    fromdate,
    duedate,
    ROW_NUMBER() OVER (PARTITION BY loan_id ORDER BY fromdate),
    COALESCE(principal_amount, 0),
    COALESCE(principal_completed_derived, 0),
    COALESCE(interest_amount, 0),
    COALESCE(interest_completed_derived, 0),
    (principal_amount IS NULL OR principal_amount = principal_completed_derived) 
        AND (interest_amount IS NULL OR interest_amount = interest_completed_derived),
    false
FROM public.m_loan_repayment_schedule_view
WHERE duedate IS NOT null

-- m_loan_repayment end

--m_savings_account

-- investment
INSERT INTO m_savings_account (account_no, external_id, client_id, group_id, product_id, status_enum, deposit_type_enum, submittedon_date, approvedon_date, rejectedon_date, withdrawnon_date, activatedon_date, closedon_date, currency_code, currency_digits, currency_multiplesof,
nominal_annual_interest_rate, interest_compounding_period_enum, interest_posting_period_enum, interest_calculation_type_enum, interest_calculation_days_in_year_type_enum, min_required_opening_balance, lockin_period_frequency, lockin_period_frequency_enum, withdrawal_fee_for_transfer,
allow_overdraft, overdraft_limit, nominal_annual_interest_rate_overdraft, account_balance_derived, withhold_tax)
SELECT
    account_no,
    external_id,
    (SELECT id FROM m_client WHERE external_id = sv.client_external_id) client_id,
    (SELECT id FROM m_group WHERE external_id = sv.group_external_id) group_id,
    (SELECT id FROM m_savings_product WHERE description = sv.product_id) product_id,
    status_enum,
    deposit_type_enum,
    submittedon_date,
    approvedon_date,
    rejectedon_date,
    withdrawnon_date,
    activatedon_date,
    closedon_date,
    currency_code,
    currency_digits,
    currency_multiplesof,
    COALESCE(interestrate, 0),
    interest_compounding_period_enum,
    interest_posting_period_enum,
    interest_calculation_type_enum,
    interest_calculation_days_in_year_type_enum,
    min_required_opening_balance,
    lockin_period_frequency,
    lockin_period_frequency_enum,
    withdrawal_fee_for_transfer,
    allow_overdraft,
    overdraft_limit,
    nominal_annual_interest_rate_overdraft,
    account_balance,
    withhold_tax
FROM m_savings_account_view sv;

--wallet

INSERT INTO m_savings_account (account_no, external_id, client_id, group_id, product_id, status_enum, deposit_type_enum, submittedon_date, approvedon_date, rejectedon_date, withdrawnon_date, activatedon_date, closedon_date, currency_code, currency_digits, currency_multiplesof,
nominal_annual_interest_rate, interest_compounding_period_enum, interest_posting_period_enum, interest_calculation_type_enum, interest_calculation_days_in_year_type_enum, min_required_opening_balance, lockin_period_frequency, lockin_period_frequency_enum, withdrawal_fee_for_transfer,
allow_overdraft, overdraft_limit, nominal_annual_interest_rate_overdraft, account_balance_derived, withhold_tax)
SELECT
    account_no,
    external_id,
    (SELECT id FROM m_client WHERE external_id = sv.client_external_id) client_id,
    (SELECT id FROM m_group WHERE external_id = sv.group_external_id) group_id,
    (SELECT id FROM m_savings_product WHERE description = sv.product_id) product_id,
    status_enum,
    deposit_type_enum,
    submittedon_date,
    approvedon_date,
    rejectedon_date,
    withdrawnon_date,
    activatedon_date,
    closedon_date,
    currency_code,
    currency_digits,
    currency_multiplesof,
    COALESCE(interestrate, 0),
    interest_compounding_period_enum,
    interest_posting_period_enum,
    interest_calculation_type_enum,
    interest_calculation_days_in_year_type_enum,
    min_required_opening_balance,
    lockin_period_frequency,
    lockin_period_frequency_enum,
    withdrawal_fee_for_transfer,
    allow_overdraft,
    overdraft_limit,
    nominal_annual_interest_rate_overdraft,
    account_balance,
    withhold_tax
FROM m_savings_account_view2 sv;

-- m_savings_account end


-- m_savings_account_transaction

ALTER TABLE m_payment_type
ADD COLUMN external_id VARCHAR(100),
ADD CONSTRAINT uq_external_id UNIQUE (external_id);

ALTER TABLE m_savings_account_transaction
ADD COLUMN encoded_key VARCHAR(100),
ADD CONSTRAINT uq_encoded_key UNIQUE (encoded_key);

ALTER TABLE m_payment_detail
ADD COLUMN transaction_external_id VARCHAR(100),
ADD CONSTRAINT uq_transaction_external_id UNIQUE (transaction_external_id);

INSERT INTO m_payment_detail (payment_type_id, transaction_external_id)
SELECT
    (SELECT id FROM m_payment_type WHERE external_id = stv.transaction_channel_key) payment_type_id,
    stv.external_id
FROM m_savings_account_transaction_view2 stv;

INSERT INTO m_savings_account_transaction (savings_account_id, office_id, encoded_key, payment_detail_id, transaction_type_enum, is_reversed, 
    transaction_date, amount, overdraft_amount_derived, running_balance_derived, created_date, ref_no)
SELECT
    (SELECT id FROM m_savings_account WHERE external_id = stv.account_external_id) savings_account_id,
    1 office_id,
    external_id,
    (SELECT id FROM m_payment_detail WHERE transaction_external_id = stv.external_id) payment_detail_id,
    transaction_type_enum,
    is_reversed,
    transaction_date,
    transaction_amount,
    overdraft_amount,
    running_balance,
    creation_date,
    reversal_transaction_key
FROM m_savings_account_transaction_view stv WHERE transaction_amount IS NOT NULL;

INSERT INTO m_savings_account_transaction (savings_account_id, office_id, encoded_key, payment_detail_id, transaction_type_enum, is_reversed, 
    transaction_date, amount, overdraft_amount_derived, running_balance_derived, created_date, ref_no)
SELECT
    (SELECT id FROM m_savings_account WHERE external_id = stv.account_external_id) savings_account_id,
    1 office_id,
    external_id,
    (SELECT id FROM m_payment_detail WHERE transaction_external_id = stv.external_id) payment_detail_id,
    transaction_type_enum,
    is_reversed,
    transaction_date,
    transaction_amount,
    overdraft_amount,
    running_balance,
    creation_date,
    reversal_transaction_key
FROM m_savings_account_transaction_view2 stv WHERE transaction_amount IS NOT NULL;

UPDATE m_savings_account_transaction t1 SET original_transaction_id = t2.id
FROM m_savings_account_transaction t2
WHERE t2.encoded_key = t1.ref_no;

UPDATE m_savings_account_transaction
SET office_id = m_client.office_id
FROM m_savings_account
JOIN m_client ON m_client.id = m_savings_account.client_id
WHERE m_savings_account_transaction.savings_account_id = m_savings_account.id;

-- m_savings_account_transaction end

-- m_note

INSERT INTO m_note(savings_account_transaction_id, note_type_enum, note, created_date)
SELECT
    (SELECT id FROM m_savings_account_transaction WHERE encoded_key = stv.external_id) savings_account_transaction_id,
    800 note_type_enum,
    transaction_notes,
    creation_date
FROM m_savings_account_transaction_view stv WHERE transaction_notes IS NOT NULL;

INSERT INTO m_note(savings_account_transaction_id, note_type_enum, note, created_date)
SELECT
    (SELECT id FROM m_savings_account_transaction WHERE encoded_key = stv.external_id) savings_account_transaction_id,
    800 note_type_enum,
    transaction_notes,
    creation_date
FROM m_savings_account_transaction_view2 stv WHERE transaction_notes IS NOT NULL;

-- m_note end

