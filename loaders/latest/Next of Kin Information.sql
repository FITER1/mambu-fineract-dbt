-- Create the Next of Kin Information table
/*CREATE TABLE public."Next of Kin Information" (
    client_id int8 NOT NULL UNIQUE,
    "State of Residence" int4 NULL,
    "Next of Kin Relationship" int4 NULL,
    "Local Government Area NOK" text NULL,
    "Next of Kin Phone Number" text NULL,
    "Next of Kin Address1" text NULL,
    "Next of Kin Name" text NULL,
    "Next of Kin Address2" text NULL,
    created_at timestamp NULL,
    updated_at timestamp NULL,
    CONSTRAINT nok_info_client_fk FOREIGN KEY (client_id) REFERENCES public.m_client(id)
);*/

-- Insert data into Next of Kin Information table
INSERT INTO public."Next of Kin Information" (
    client_id, 
    "State of Residence",
    "Next of Kin Relationship",
    "Local Government Area  NOK",
    "Next of Kin Phone Number",
    "Next of Kin Address1",
    "Next of Kin Name",
    "Next of Kin Address2",
    created_at, 
    updated_at
)
SELECT 
    m_client.id AS client_id,
   (SELECT id FROM m_code_value WHERE LOWER(code_value) = LOWER(cf_state."VALUE") AND code_id = 27)::int4 AS "State of Residence",
    (SELECT id FROM m_code_value WHERE LOWER(code_value) = LOWER(cf_relationship."VALUE") AND code_id = 104)::int4 AS "Next of Kin Relationship",
    cf_lga."VALUE" AS "Local Government Area - NOK",
    cf_phone."VALUE" AS "Next of Kin Phone Number",
    cf_address1."VALUE" AS "Next of Kin Address1",
    cf_name."VALUE" AS "Next of Kin Name",
    cf_address2."VALUE" AS "Next of Kin Address2",
    m_client.submittedon_date AS created_at,
    m_client.submittedon_date AS updated_at
FROM m_client
    LEFT JOIN customfieldvalue cf_state ON m_client.external_id = cf_state.parentkey AND cf_state.customfieldkey = '8aad33cd46f34dc80146fb7910fe5ae8'
    LEFT JOIN customfieldvalue cf_relationship ON m_client.external_id = cf_relationship.parentkey AND cf_relationship.customfieldkey = '8aff211e4246fcd7014247386c5c0493'
    LEFT JOIN customfieldvalue cf_lga ON m_client.external_id = cf_lga.parentkey AND cf_lga.customfieldkey = '8a858e65582a517e015840515bf163fa'
    LEFT JOIN customfieldvalue cf_phone ON m_client.external_id = cf_phone.parentkey AND cf_phone.customfieldkey = '8aff211e4246fcd701424739686104f9'
    LEFT JOIN customfieldvalue cf_address1 ON m_client.external_id = cf_address1.parentkey AND cf_address1.customfieldkey = '8aff211e4246fcd701424739a66404fd'
    LEFT JOIN customfieldvalue cf_name ON m_client.external_id = cf_name.parentkey AND cf_name.customfieldkey = '8aff211e4246fcd701424734447603fa'
    LEFT JOIN customfieldvalue cf_address2 ON m_client.external_id = cf_address2.parentkey AND cf_address2.customfieldkey = '8aad33cd46f34dc80146fb774ad65952';

