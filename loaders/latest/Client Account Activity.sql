INSERT INTO public."Client Account Activity" 
(
    loan_id,
    "Total Debits",
    "Total Credits",
    "Opening Date of Statement",
    "Closing Date of Statement",
    "Opening Account Balance",
    "Closing Account Balance",
    "Highest Balance",
    "Date of Highest Balance",
    created_at,
    updated_at
)
SELECT 
    m.id AS loan_id,
    c1."VALUE"::int AS "Total Debits",
    c2."VALUE"::int AS "Total Credits",
    c3."VALUE"::date AS "Opening Date of Statement",
    c4."VALUE"::date AS "Closing Date of Statement",
    c5."VALUE"::numeric(19,2) AS "Opening Account Balance",
    c6."VALUE"::numeric(19,2) AS "Closing Account Balance",
    c7."VALUE"::numeric(19,2) AS "Highest Balance",
    c8."VALUE"::date AS "Date of Highest Balance",
    m.submittedon_date AS created_at,
    m.submittedon_date AS updated_at
FROM 
    m_loan AS m
LEFT JOIN customfieldvalue c1 ON m.external_id = c1.parentkey AND c1.customfieldkey = '8a858f3e589c40610158b4c3c6da48ab'
LEFT JOIN customfieldvalue c2 ON m.external_id = c2.parentkey AND c2.customfieldkey = '8a858f3e589c40610158b4c579a24945'
LEFT JOIN customfieldvalue c3 ON m.external_id = c3.parentkey AND c3.customfieldkey = '8a858f3e589c40610158b4c76eaf49b7'
LEFT JOIN customfieldvalue c4 ON m.external_id = c4.parentkey AND c4.customfieldkey = '8a858f3e589c40610158b4cf043f4d2c'
LEFT JOIN customfieldvalue c5 ON m.external_id = c5.parentkey AND c5.customfieldkey = '8a858f3e589c40610158b4e6386654cb'
LEFT JOIN customfieldvalue c6 ON m.external_id = c6.parentkey AND c6.customfieldkey = '8a858f3e589c40610158b4fa44205b39'
LEFT JOIN customfieldvalue c7 ON m.external_id = c7.parentkey AND c7.customfieldkey = '8a858eb858b1a6d20158b4fc51757337'
LEFT JOIN customfieldvalue c8 ON m.external_id = c8.parentkey AND c8.customfieldkey = '8a858eb858b1a6d20158b50b45e977b0'
on conflict (loan_id) do nothing;
