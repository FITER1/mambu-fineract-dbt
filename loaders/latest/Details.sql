-- Create the Details table
/*CREATE TABLE public."Details" (
    client_id int8 NOT NULL UNIQUE,
    "Birth Date" date NULL,
    Gender int4 NULL,
    "EMail Address" text NULL,
    "Mobile Phone" text NULL,
    "Mobile Phone2" text NULL,
    "Home Phone" text NULL,
    created_at timestamp NULL,
    updated_at timestamp NULL,
    CONSTRAINT details_client_fk FOREIGN KEY (client_id) REFERENCES public.m_client(id)
);*/

-- Insert data into Details table
INSERT INTO public."Details" (
    client_id, 
    "Birth Date", 
    Gender, 
    "EMail Address", 
    "Mobile Phone", 
    "Mobile Phone2", 
    "Home Phone", 
    created_at, 
    updated_at
)
SELECT 
    m_client.id AS client_id,
    cf_birthdate."VALUE"::date AS "Birth Date",
   (SELECT id FROM m_code_value WHERE LOWER(code_value) = LOWER(cf_gender."VALUE") AND code_id = 4)::int4 AS  Gender,
    cf_email."VALUE" AS "EMail Address",
    cf_mobile1."VALUE" AS "Mobile Phone",
    cf_mobile2."VALUE" AS "Mobile Phone2",
    cf_homephone."VALUE" AS "Home Phone",
    m_client.submittedon_date AS created_at,
    m_client.submittedon_date AS updated_at
FROM m_client
    LEFT JOIN customfieldvalue cf_birthdate ON m_client.external_id = cf_birthdate.parentkey AND cf_birthdate.customfieldkey = '8a85898b548f54af01548f6a87e66b14'
    LEFT JOIN customfieldvalue cf_gender ON m_client.external_id = cf_gender.parentkey AND cf_gender.customfieldkey = '8a85898b548f54af01548f6a87eb6b7c'
    LEFT JOIN customfieldvalue cf_email ON m_client.external_id = cf_email.parentkey AND cf_email.customfieldkey = '8a85898b548f54af01548f6a881a6c01'
    LEFT JOIN customfieldvalue cf_mobile1 ON m_client.external_id = cf_mobile1.parentkey AND cf_mobile1.customfieldkey = '8a85898b548f54af01548f6a87f76bbb'
    LEFT JOIN customfieldvalue cf_mobile2 ON m_client.external_id = cf_mobile2.parentkey AND cf_mobile2.customfieldkey = '8a858f30715e2a3701715e2dd75c18dd'
    LEFT JOIN customfieldvalue cf_homephone ON m_client.external_id = cf_homephone.parentkey AND cf_homephone.customfieldkey = '8a85898b548f54af01548f6a880a6bc5'
    on conflict (client_id) do nothing;;

