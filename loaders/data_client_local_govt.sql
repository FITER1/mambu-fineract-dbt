-- Local Government
INSERT INTO "Local Government"
SELECT 
(SELECT id FROM m_client WHERE external_id = c.ENCODEDKEY)::integer client_id,
lga.local_govt
FROM final_client c
JOIN (SELECT
		PARENTKEY,
		"VALUE" local_govt
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587ff5826ac510158299815e32f1e') lga
ON c.ENCODEDKEY = lga.PARENTKEY;