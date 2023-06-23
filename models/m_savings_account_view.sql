{{ config(materialized='table') }}

WITH base AS (
    SELECT *,
        encodedkey as external_id,
        accountholdertype,
        accountholderkey as account_holder_key,
        accounttype,
        accountstate as accountstate,
        accruedinterest,
        balance,
        closeddate,
        creationdate,
        approveddate,
        activationdate,
        "ID" as account_no,
        lastinterestcalculationdate,
        lastintereststoreddate,
        lastmodifieddate,
        maturitydate,
        "NAME",
        notes,
        PRODUCTTYPEKEY as product_type_key,
        allowoverdraft,
        overdraftlimit,
        WITHHOLDINGTAXSOURCEKEY
    FROM {{ ref('final_investment') }}
),

client_view AS (
    SELECT *
    FROM m_client_view
),

group_view AS (
    SELECT *
    FROM m_group_view
),

product_view AS (
    SELECT *
    FROM m_savings_product_view
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
    CASE WHEN b.accountholdertype = 'CLIENT' THEN cv.id ELSE NULL END as client_id,
    cv.external_id as client_external_id,
    CASE WHEN b.accountholdertype = 'GROUP' THEN gv.id ELSE NULL END as group_id,
    gv.external_id as group_external_id,
    CASE
        WHEN b.accounttype = 'FIXED_DEPOSIT' THEN 200
        WHEN b.accounttype IN ('SAVINGS_PLAN', 'REGULAR_SAVINGS') THEN 100
        ELSE 300
    END as deposit_type_enum,
    CASE
        WHEN b.accountstate  = 'MATURED' THEN 800
        WHEN b.accountstate = 'WITHDRAWN' THEN 400
        WHEN b.accountstate  = 'CLOSED' THEN 600
        WHEN b.accountstate = 'ACTIVE' THEN 300
        WHEN b.accountstate = 'APPROVED' THEN 200
        WHEN b.accountstate = 'CLOSED_REJECTED' THEN 500
        ELSE 100
    END as  status_enum,
    b.creationdate as submittedon_date,
    b.approveddate as approvedon_date,
    b.activatedon_date as activationdate,
    CASE
        WHEN b.accountstate = 'CLOSED_REJECTED' THEN b.closeddate
        ELSE NULL
    END as  rejectedon_date,
    CASE
        WHEN b.accountstate = 'WITHDRAWN' THEN b.closeddate
        ELSE NULL
    END as  withdrawnon_date,
    b.closeddate as closedon_date,
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
        WHEN b.allowoverdraft = 1 THEN true
        ELSE false
    END as allow_overdraft,
    b.overdraftlimit as overdraft_limit,
    oist.interestrate as nominal_annual_interest_rate_overdraft,
    b.balance as account_balance,
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
LEFT JOIN office_view ov
    ON b.assignedbranchkey = ov.external_id
LEFT JOIN staff_view sv
    ON b.assigneduserkey = sv.external_id
LEFT JOIN interest_settings ist
    ON b.INTERESTRATESETTINGSKEY = ist.encodedkey
LEFT JOIN interest_settings oist
    ON b.OVERDRAFTINTERESTRATESETTINGSKEY = oist.encodedkey
LEFT JOIN indexratesource irs ON b.WITHHOLDINGTAXSOURCEKEY = irs.encodedkey
LEFT JOIN indexrate ir ON ir.INDEXINTERESTRATESOURCE_ENCODEDKEY_OID = irs.encodedkey

