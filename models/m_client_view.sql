{{
    config(
        materialized = 'table'
    )
}}


WITH base AS (
    SELECT 
        ROW_NUMBER() OVER () + (SELECT MAX(id) FROM "public"."m_client") as id,
        encodedkey as external_id,
        assigneduserkey as assigneduserkey,
        "birthdate" as date_of_birth,
        "creationdate" as submittedon_date,
        firstname as firstname,
        middlename as middlename,
        lastname as lastname,
        (SELECT id FROM m_code_value WHERE code_value = gender)  as gender_cv_id,
        "lastmodifieddate" as last_modified_on_utc,
        "lastmodifieddate" as updated_on,
        "ID" as account_no,
        "mobilephone1" as mobile_no,
        COALESCE(o.id, 1) as office_id,
        o.external_id as office_external_id,
        CASE 
            WHEN "STATE" = 'ACTIVE' THEN 300 
            WHEN "STATE" = 'EXITED' THEN 600
            WHEN "STATE" = 'INACTIVE' THEN 100
            WHEN "STATE" = 'BLACKLISTED' THEN 400
            ELSE 0 
        END as status_enum,
        "activationdate" as activation_date,
        "closeddate" as closedon_date
    FROM {{ ref('final_client') }} c
    LEFT JOIN {{ ref('m_office_view') }} as  o ON o.external_id = c.assignedbranchkey
),
staff_view AS(
select id, external_id 
from m_staff_view
union 
select id, external_id 
from m_staff
), 
client as (
    SELECT  b.*, s1.id as created_by,s1.id as last_modified_by 
    from base b 
    left join staff_view as  s1 on b.assigneduserkey = s1.external_id -- corrected join condition
)
SELECT * FROM client
