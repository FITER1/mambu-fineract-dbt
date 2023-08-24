{{ config(materialized='table') }}
{{ load_relation(ref('m_staff_view')) }}

WITH decoded_user AS (
    SELECT 
        encodedkey AS user_external_id,
        "ID" AS id,
        username AS username,
        firstname AS firstname,
        lastname AS lastname,
        "PASSWORD" AS password,
        email AS email
    FROM {{ ref('user2') }}
),
staff_view AS (
    SELECT id,external_id,office_id
    FROM m_staff_view

    UNION 

    SELECT id,external_id,office_id
    FROM m_staff
),
user_office AS (
    SELECT 
        du.user_external_id,
        du.id,
        du.username,
        du.firstname,
        du.lastname,
        du.password,
        du.email,
        s.office_id
    FROM decoded_user AS du
    LEFT JOIN staff_view s ON du.user_external_id = s.external_id
)

SELECT 
    uo.id::int8 as id,
    FALSE as is_deleted,
    COALESCE(uo.office_id, 1) as office_id,
    uo.id as staff_id,
    uo.username,
    COALESCE(uo.firstname, '') as firstname,
    COALESCE(uo.lastname, '') as lastname,
    COALESCE(uo.password, '') as password,
    COALESCE(uo.email, '') as email,
    TRUE as firsttime_login_remaining,
    TRUE as nonexpired,
    TRUE as nonlocked,
    TRUE as nonexpired_credentials,
    TRUE as enabled,
    CURRENT_DATE as last_time_password_updated,
    FALSE as password_never_expires,
    FALSE as is_self_service_user,
    FALSE as cannot_change_password
FROM user_office AS uo
