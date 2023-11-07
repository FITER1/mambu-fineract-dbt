    
INSERT INTO public."Employment Information"
(
            client_id, 
            "employment_type_cd_Employment Status",
            "Employer",
            "Date of Employment",
            "Net Pay",
            "Pay Date",
            "State",
             "Name of Business",
            "Business Start Date",
            created_at,
            updated_at,
            "Contract Expiry Date",
            "Verification Number",
            "Number of Employers in the last five years",
            "Office Address",
            "Employee Number",
            "Employer Industry",
            "Office Address2",
            "Local Government Area",
            "Job Title Position"
)
SELECT 
    c.id,
    (SELECT cv1.id FROM m_code_value cv1 WHERE cv1.code_id = 89 AND LOWER(cv1.code_value) = LOWER(cf1."VALUE")),
    cf2."VALUE",
    cf3."VALUE"::date,
--    cf4."VALUE"::decimal(22,2),
     CASE
                WHEN cf4."VALUE"::numeric < 10^20 AND cf4."VALUE"::numeric > -10^20 THEN cf4."VALUE"::decimal(22,2)
                                ELSE NULL 
                                            END,
    cf5."VALUE"::date,
    (SELECT cv2.id FROM m_code_value cv2 WHERE cv2.code_id = 27 AND LOWER(cv2.code_value) = LOWER(cf6."VALUE")),
    cf7."VALUE",
    cf8."VALUE"::date,
    c.submittedon_date,
    c.submittedon_date,
    cf9."VALUE"::date,
        CASE
                    WHEN cf10."VALUE" ~ '^\d+$' THEN cf10."VALUE"::bigint
                            ELSE NULL 
                        END,
        CASE
    WHEN cf11."VALUE" ~ '^\d+$' THEN cf11."VALUE"::bigint
    ELSE NULL 
END,

    --cf10."VALUE"::bigint,
   -- cf11."VALUE"::bigint,
    cf12."VALUE",
    cf13."VALUE",
    cf14."VALUE",
    cf15."VALUE",
    cf16."VALUE",
    cf17."VALUE"
FROM 
    m_client c
    LEFT JOIN customfieldvalue cf1 ON cf1.parentkey = c.external_id AND cf1.customfieldkey = '8a5ced2443e0bf990143e2bbdaf70642'
    LEFT JOIN customfieldvalue cf2 ON cf2.parentkey = c.external_id AND cf2.customfieldkey = '8a6b840a4202095c0142040cffca4752'
    LEFT JOIN customfieldvalue cf3 ON cf3.parentkey = c.external_id AND cf3.customfieldkey = '8afacb4d42b1eece0142b278f66c12a8'
    LEFT JOIN customfieldvalue cf4 ON cf4.parentkey = c.external_id AND cf4.customfieldkey = '8a6b840a4202095c0142040e597247cb'
    LEFT JOIN customfieldvalue cf5 ON cf5.parentkey = c.external_id AND cf5.customfieldkey = '8a5ced2443e0bf990143e2e6191b23d6'
    LEFT JOIN customfieldvalue cf6 ON cf6.parentkey = c.external_id AND cf6.customfieldkey = '8aad33cd46f34dc80146fb73c1b85735'
    LEFT JOIN customfieldvalue cf7 ON cf7.parentkey = c.external_id AND cf7.customfieldkey = '8a6a80714f1c6f97014f225837f12934'
    LEFT JOIN customfieldvalue cf8 ON cf8.parentkey = c.external_id AND cf8.customfieldkey = '8a1a0ff8506bd35701507131e9f272cc'
    LEFT JOIN customfieldvalue cf9 ON cf9.parentkey = c.external_id AND cf9.customfieldkey = '8a26b6ee4eab9528014eb6453cdc59de'
    LEFT JOIN customfieldvalue cf10 ON cf10.parentkey = c.external_id AND cf10.customfieldkey = '8a858e085cc5b826015cc615e1053501'
    LEFT JOIN customfieldvalue cf11 ON cf11.parentkey = c.external_id AND cf11.customfieldkey = '8a5ced2443e0bf990143e2ba607004c7'
    LEFT JOIN customfieldvalue cf12 ON cf12.parentkey = c.external_id AND cf12.customfieldkey = '8a6b840a4202095c0142040d6def4769'
    LEFT JOIN customfieldvalue cf13 ON cf13.parentkey = c.external_id AND cf13.customfieldkey = '8a6b840a4202095c0142040e33d247c8'
    LEFT JOIN customfieldvalue cf14 ON cf14.parentkey = c.external_id AND cf14.customfieldkey = '8a858e65582a517e01584059f9806538'
    LEFT JOIN customfieldvalue cf15 ON cf15.parentkey = c.external_id AND cf15.customfieldkey = '8aad33cd46f34dc80146fb69283550d8'
    LEFT JOIN customfieldvalue cf16 ON cf16.parentkey = c.external_id AND cf16.customfieldkey = '8a858e65582a517e0158404f592c63ec'
    LEFT JOIN customfieldvalue cf17 ON cf17.parentkey = c.external_id AND cf17.customfieldkey = '8a5ced2443e0bf990143e2eba4a9253d'
    on conflict (client_id) do nothing;