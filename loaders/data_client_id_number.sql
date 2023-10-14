-- Identification Number
INSERT INTO "Identification Number" (client_id, "Id number")
SELECT 
id,
ft.id_number
FROM m_client c
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS id_number
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a6b840a4202095c0142040e33d247c8') ft
ON c.external_id = ft.PARENTKEY
on conflict(client_id) do nothing;

-- Identification Number end