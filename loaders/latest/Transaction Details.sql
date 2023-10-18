-- Create the Transaction Details table
/*CREATE TABLE public."Transaction Details" (
    savings_account_id int8 NOT NULL UNIQUE,
    "Transaction Sweep out Status" bit NULL,
    "Discounted Repayment" bit NULL,
    "Excess Payment" DECIMAL(22,2) NULL,
    "Third Party Liquidation Amount" DECIMAL(22,2) NULL,
    "Bank Account Details" int4 NULL,
    "Identifier" text NULL,
    "Account Number" text NULL,
    "Related Account ID" text NULL,
    "Savings Account Name" text NULL,
    "Account Product Name" text NULL,
    "Transaction Category" text NULL,
    created_at timestamp NULL,
    updated_at timestamp NULL,
    CONSTRAINT trans_details_savings_acc_fk FOREIGN KEY (savings_account_id) REFERENCES public.m_savings_account(id)
);*/

-- Insert data into Transaction Details table using joins with m_savings_account and customfieldvalue
INSERT INTO public."Transaction Details" (
    savings_account_id, 
    "Transaction Sweep out Status",
    "Discounted Repayment",
    "Excess Payment",
    "Third Party Liquidation Amount",
    "Bank Account Details",
    "Identifier",
    "Account Number",
    "Related Account ID",
    "Savings Account Name",
    "Account Product Name",
    "Transaction Category",
    created_at, 
    updated_at
)
SELECT 
    msa.id, 
    CASE WHEN cf1."VALUE"= 'TRUE' THEN '1'::bit ELSE '0'::bit END,
    CASE WHEN cf2."VALUE"= 'TRUE' THEN '1'::bit ELSE '0'::bit END,
    cf3."VALUE"::decimal(22,2),
    cf4."VALUE"::decimal(22,2),
     (SELECT id FROM m_code_value WHERE LOWER(code_value) = LOWER(cf5."VALUE") AND code_id = 82)::int4,
    cf6."VALUE",
    cf7."VALUE",
    cf8."VALUE",
    cf9."VALUE",
    cf10."VALUE",
    cf11."VALUE",
    msa.submittedon_date,
    msa.submittedon_date
FROM m_savings_account msa
    LEFT JOIN customfieldvalue cf1 ON msa.external_id = cf1.parentkey AND cf1.customfieldkey = '8a858f0a6cb8329d016cb8a17a8f2bff'
    LEFT JOIN customfieldvalue cf2 ON msa.external_id = cf2.parentkey AND cf2.customfieldkey = '8a858f72819034b10181a627445f79ef'
    LEFT JOIN customfieldvalue cf3 ON msa.external_id = cf3.parentkey AND cf3.customfieldkey = '8a858fe762afcc850162b08be2287b90'
    LEFT JOIN customfieldvalue cf4 ON msa.external_id = cf4.parentkey AND cf4.customfieldkey = '8a858f0a6cb8329d016cb89fc6eb2b57'
    LEFT JOIN customfieldvalue cf5 ON msa.external_id = cf5.parentkey AND cf5.customfieldkey = '8a858e566139f00c016143174a6d32f8'
    LEFT JOIN customfieldvalue cf6 ON msa.external_id = cf6.parentkey AND cf6.customfieldkey = '8a85898b548f54af01548f6a886c6ceb'
    LEFT JOIN customfieldvalue cf7 ON msa.external_id = cf7.parentkey AND cf7.customfieldkey = '8a85898b548f54af01548f6a887e6d21'
    LEFT JOIN customfieldvalue cf8 ON msa.external_id = cf8.parentkey AND cf8.customfieldkey = '8a858e62644759ec01644a9eb4cb0f0d'
    LEFT JOIN customfieldvalue cf9 ON msa.external_id = cf9.parentkey AND cf9.customfieldkey = '8a858f0a6cb8329d016cb8aadd9a2ed0'
    LEFT JOIN customfieldvalue cf10 ON msa.external_id = cf10.parentkey AND cf10.customfieldkey = '8a858f0a6cb8329d016cb8afaae43155'
    LEFT JOIN customfieldvalue cf11 ON msa.external_id = cf11.parentkey AND cf11.customfieldkey = '8a858e62644759ec01644a9a084c0d25';
