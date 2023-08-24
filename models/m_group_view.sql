{{
    config(
        materialized='table'
    )
}}
{{ adapter.get_relation('m_office_view') }}
{{ adapter.get_relation('m_staff_view') }}
WITH office_view AS (
    SELECT id,external_id
    FROM m_office_view

    UNION

    SELECT id,external_id
    FROM m_office
),
staff_view AS (
    SELECT id,external_id
    FROM m_staff_view

    UNION 

    SELECT id,external_id
    FROM m_staff
)
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
LEFT JOIN office_view  office
ON "assignedbranchkey" = office.external_id
LEFT JOIN staff_view staff
ON "assigneduserkey" = staff.external_id
