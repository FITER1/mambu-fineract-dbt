WITH decoded_document AS (
    SELECT
        encodedkey,
        "LOCATION" AS "LOCATION",
        filesize,
        creationdate,
        lastmodifieddate,
        "NAME",
        documentholderkey,
        createdbyuserkey,
        originalfilename,
        "description" AS description,
        documentholdertype,
        "ID",
        "TYPE"
    FROM {{ ref('document') }}
)
SELECT
    "ID" AS id,
    "NAME" AS name,
    "originalfilename" AS file_name,
    filesize AS size,
    "TYPE" AS type,
    "description" AS description,
    "LOCATION" AS location,
    NULL AS storage_type_enum
FROM decoded_document
