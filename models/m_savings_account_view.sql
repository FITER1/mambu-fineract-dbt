{{ config(materialized='table') }}
{{ adapter.get_relation('m_client_view') }}
{{ adapter.get_relation('m_group_view') }}
{{ adapter.get_relation('m_savings_product_view') }}

WITH base AS (
    SELECT *,
        encodedkey as external_id,
        accountholdertype as account_holder_type,
        accountholderkey as account_holder_key,
        accounttype as account_type,
        accountstate as account_state,
        accruedinterest,
        balance as account_balance,
        closeddate as closed_date,
        creationdate as creation_date,
        approveddate as approved_date,
        activationdate as activation_date,
        "ID" as account_no,
        lastinterestcalculationdate,
        lastintereststoreddate,
        lastmodifieddate,
        maturitydate,
        "NAME",
        notes,
        PRODUCTTYPEKEY as product_type_key,
        allowoverdraft as allow_overdraft,
        overdraftlimit as overdraft_limit,
        WITHHOLDINGTAXSOURCEKEY as withholding_tax_source_key,
        INTERESTSETTINGSKEY as interest_settings_key,
        OVERDRAFTINTERESTSETTINGSKEY as overdraft_interest_settings_key
    FROM {{ ref('final_investment') }}
),

client_view AS (
    SELECT id, external_id 
    FROM m_client_view

    UNION

    SELECT id, external_id 
    FROM m_client
),

group_view AS (
    SELECT id, external_id 
    FROM m_group_view

    UNION 

    SELECT id, external_id 
    FROM m_group
),

product_view AS (
    SELECT external_id,currency_code,currency_digits,currency_multiplesof,interest_compounding_period_enum,
    interest_posting_period_enum,interest_calculation_type_enum,interest_calculation_days_in_year_type_enum,
    min_required_opening_balance,lockin_period_frequency,lockin_period_frequency_enum,withdrawal_fee_for_transfer
    FROM m_savings_product_view
    
    UNION
    
    SELECT description,currency_code,currency_digits,currency_multiplesof,interest_compounding_period_enum,
    interest_posting_period_enum,interest_calculation_type_enum,interest_calculation_days_in_year_type_enum,
    min_required_opening_balance,lockin_period_frequency,lockin_period_frequency_enum,withdrawal_fee_for_transfer
    FROM m_savings_product
),

interest_settings AS (
    SELECT *
    FROM interestaccountsettings
)

SELECT
    ROW_NUMBER() OVER () as id,
    b.external_id,
    b.account_no,
    pv.external_id as product_id,
    CASE WHEN b.account_holder_type = 'CLIENT' THEN cv.id ELSE NULL END as client_id,
    cv.external_id as client_external_id,
    CASE WHEN b.account_holder_type = 'GROUP' THEN gv.id ELSE NULL END as group_id,
    gv.external_id as group_external_id,
    CASE
        WHEN b.account_type = 'FIXED_DEPOSIT' THEN 200
        ELSE 100
    END as deposit_type_enum,
    CASE
        WHEN b.account_state  = 'MATURED' THEN 800
        WHEN b.account_state = 'WITHDRAWN' THEN 400
        WHEN b.account_state  = 'CLOSED' THEN 600
        WHEN b.account_state = 'ACTIVE' THEN 300
        WHEN b.account_state = 'APPROVED' THEN 200
        WHEN b.account_state = 'CLOSED_REJECTED' THEN 500
        ELSE 100
    END as  status_enum,
    b.creation_date as submittedon_date,
    b.approved_date as approvedon_date,
    b.activation_date as activatedon_date,
    CASE
        WHEN b.account_state = 'CLOSED_REJECTED' THEN b.closeddate
        ELSE NULL
    END as  rejectedon_date,
    CASE
        WHEN b.account_state = 'WITHDRAWN' THEN b.closeddate
        ELSE NULL
    END as  withdrawnon_date,
    b.closed_date as closedon_date,
    pv.currency_code,
    pv.currency_digits,
    pv.currency_multiplesof,
    ist.interestrate,
    pv.interest_compounding_period_enum,
    pv.interest_posting_period_enum,
    pv.interest_calculation_type_enum,
    pv.interest_calculation_days_in_year_type_enum,
    pv.min_required_opening_balance,
    pv.lockin_period_frequency,
    pv.lockin_period_frequency_enum,
    pv.withdrawal_fee_for_transfer,
    CASE
        WHEN b.allow_overdraft = true THEN true
        ELSE false
    END as allow_overdraft,
    b.overdraft_limit as overdraft_limit,
    oist.interestrate as nominal_annual_interest_rate_overdraft,
    b.account_balance as account_balance,
    CASE
        WHEN ir.RATE IS NOT NULL THEN true
        ELSE false
    END as withhold_tax
FROM base b
JOIN product_view pv
    ON b.product_type_key = pv.external_id
LEFT JOIN client_view cv
    ON b.account_holder_key = cv.external_id
LEFT JOIN group_view gv
    ON b.account_holder_key = gv.external_id
LEFT JOIN interest_settings ist
    ON b.interest_settings_key = ist.encodedkey
LEFT JOIN interest_settings oist
    ON b.overdraft_interest_settings_key = oist.encodedkey
LEFT JOIN indexratesource irs ON b.withholding_tax_source_key = irs.encodedkey
LEFT JOIN indexrate ir ON ir.INDEXINTERESTRATESOURCE_ENCODEDKEY_OID = irs.encodedkey

