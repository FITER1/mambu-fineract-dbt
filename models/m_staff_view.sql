{{ config(materialized='table') }}
{{ adapter.get_relation('m_role_view') }}
{{ adapter.get_relation('m_office_view') }}


WITH branch_office AS (
    SELECT 
        external_id AS office_external_id,
        id AS office_id
    FROM m_office_view

    UNION 

    SELECT 
        external_id AS office_external_id,
        id AS office_id
    FROM m_office
),
role_view AS (
select id,name from m_role_view

UNION

select id,name from m_role
),
roles AS (
    SELECT 
        CAST(rv.id AS int2) AS organisational_role_enum,
        encodedkey AS role_encoded_key
    FROM {{ ref('role') }}
    LEFT JOIN role_view rv ON rv.name = "NAME"
),
user_with_decoded_keys AS (
    SELECT *,
        assignedbranchkey AS decoded_assignedbranchkey,
        role_encodedkey_oid AS decoded_role_encodedkey_oid,
        firstname AS decoded_firstname,
        lastname AS decoded_lastname,
        username AS decoded_username,
        mobilephone1 AS decoded_mobile_no,
        email AS decoded_email,
        encodedkey AS decoded_external_id,
        CASE WHEN userstate = 'ACTIVE' THEN TRUE ELSE FALSE END AS decoded_is_active
    FROM {{ ref('user2') }}
)

SELECT 
    u."ID" AS id,
    CASE WHEN u.ISCREDITOFFICER = '1' THEN TRUE ELSE FALSE END AS is_loan_officer,
    bo.office_id,
    u.decoded_firstname AS firstname,
    u.decoded_lastname AS lastname,
    u.decoded_username AS display_name,
    u.decoded_mobile_no AS mobile_no,
    u.decoded_external_id as external_id,
    r.organisational_role_enum,
    CAST(NULL AS int8) AS organisational_role_parent_staff_id,
    u.decoded_is_active AS is_active,
    CAST(u.CREATIONDATE AS date) AS joining_date,
    CAST(NULL AS int8) AS image_id,  -- Assuming there's no equivalent field in the source table
    u.decoded_email AS email_address

FROM user_with_decoded_keys AS u
LEFT JOIN branch_office AS bo ON u.decoded_assignedbranchkey = bo.office_external_id
LEFT JOIN roles AS r ON u.decoded_role_encodedkey_oid = r.role_encoded_key
