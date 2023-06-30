-- Identification Number
INSERT INTO "Identification Number" (client_id, "Id number")
SELECT 
(SELECT id FROM m_client WHERE external_id = c.ENCODEDKEY)::integer client_id,
ft.id_number
FROM final_client c
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS id_number
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a6b840a4202095c0142040e33d247c8') ft
ON c.ENCODEDKEY = ft.PARENTKEY;

-- Identification Number end