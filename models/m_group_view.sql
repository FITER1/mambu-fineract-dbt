{{
    config(
        materialized='table'
    )
}}

SELECT 
    ROW_NUMBER() OVER () as id,
    "encodedkey" as external_id,
    COALESCE(office.id, 1) as office_id,
    staff.id as staff_id,
    "creationdate" as submittedon_date,
    "groupname" as display_name,
    "ID" as account_no,
    300 as status_enum, -- default value for status_enum in your PostgreSQL table
    2 as level_id -- level_name Group
FROM {{ ref('final_group') }}
LEFT JOIN {{ ref('m_office_view') }} as office
ON "assignedbranchkey" = office.external_id
LEFT JOIN {{ ref('m_staff_view') }} as staff
ON "assigneduserkey" = staff.external_id
