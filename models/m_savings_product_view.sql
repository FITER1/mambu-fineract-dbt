WITH source AS (
    SELECT
        sp.ENCODEDKEY as external_id,
        "NAME" AS name,
        sp.DESCRIPTION AS description,
        sp.PRODUCTTYPE AS product_type,
        ips.DEFAULTINTERESTRATE AS nominal_annual_interest_rate,
        sp.INTERESTPAYMENTPOINT as interest_payment_point,
        sp.ACCOUNTINGMETHOD as accounting_method,
        CASE
            WHEN cast(ALLOWOVERDRAFT as int4) = 1 THEN true
            ELSE false
        END as allow_overdraft,
        MAXOVERDRAFTLIMIT AS overdraft_limit,
        ops.DEFAULTINTERESTRATE AS nominal_interest_rate_overdraft,
        MINOPENINGBALANCE as min_required_balance,
        CASE
            WHEN cast(WITHHOLDINGTAXENABLED as int4) = 1 THEN true
            ELSE false
        END as withhold_tax,
        DORMANCYPERIODDAYS as days_to_dormancy,
        CASE
            WHEN DORMANCYPERIODDAYS IS NULL THEN false
            ELSE true
        END as is_dormancy_tracking_active
    FROM {{ ref('savingsproduct') }} as sp LEFT JOIN {{ ref('interestproductsettings') }} as ips
    ON sp.INTERESTRATESETTINGSKEY = ips.ENCODEDKEY
    LEFT JOIN {{ ref('interestproductsettings') }} as ops
    ON sp.OVERDRAFTINTERESTRATESETTINGSKEY = ops.ENCODEDKEY
)

SELECT
    cast(NULL as int8) as id,
    {{ decode_base64("name") }} as name,
    NULL as short_name,
    {{ decode_base64("external_id") }} as description, --pass external_id to description as we don't have external id on savings products
    CASE
        WHEN {{ decode_base64("product_type") }} = 'CURRENT_ACCOUNT' THEN 300
        WHEN {{ decode_base64("product_type") }} = 'FIXED_DEPOSIT' THEN 200
        ELSE 100
    END as deposit_type_enum,
    'NGN' AS currency_code,
    cast(0 as int4) as currency_digits,
    cast(1 as int4) as currency_multiplesof,
    nominal_annual_interest_rate,
    cast(1 as int4) as interest_compounding_period_enum,
    CASE
        WHEN {{ decode_base64("interest_payment_point") }} = 'ON_ACCOUNT_MATURITY' THEN 8
        ELSE 4
    END as interest_posting_period_enum,
    cast(1 as int4) as interest_calculation_type_enum,
    cast(365 as int4) as interest_calculation_days_in_year_type_enum,
    cast(NULL as numeric(19,6)) as min_required_opening_balance,
    cast(NULL as numeric(19,6)) as lockin_period_frequency_enum,
    CASE
        WHEN {{ decode_base64("accounting_method") }} = 'ACCRUAL' THEN 3
        WHEN {{ decode_base64("accounting_method") }} = 'CASH' THEN 2
        ELSE 1
    END as accounting_type,
    cast(NULL as numeric(19,6)) as withdrawal_fee_amount,
    cast(NULL as int4) as withdrawal_fee_type_enum,
    false as withdrawal_fee_for_transfer,
    allow_overdraft,
    overdraft_limit,
    nominal_interest_rate_overdraft,
    cast(0 as numeric(19,6)) as min_overdraft_for_interest_calculation,
    min_required_balance,
    false as enforce_min_required_balance,
    cast(NULL as numeric(19,6)) as min_balance_for_interest_calculation,
    withhold_tax,
    cast(NULL as int8) as tax_group_id,
    is_dormancy_tracking_active,
    cast(NULL as int4) as days_to_inactive,
    days_to_dormancy,
    cast(NULL as int4) as days_to_escheat,
    cast(NULL as numeric(19,6)) as max_allowed_lien_limit,
    false as is_lien_allowed,
    false as is_interest_posting_config_update,
    cast(NULL as int8) as num_of_credit_transaction,
    cast(NULL as int8) as num_of_debit_transaction,
    false as is_usd_product,
    false as allow_manually_enter_interest_rate,
    false as add_penalty_on_missed_target_savings,
    false as use_floating_interest_rate,
    cast(NULL as int8) as withdrawal_frequency,
    cast(NULL as int8) as withdrawal_frequency_enum,
    cast(NULL as int8) as product_category_id,
    cast(NULL as int8) as product_type_id,
    false as post_overdraft_interest_on_deposit
FROM source