-- Local Government
INSERT INTO "Local Government"
SELECT 
id,
lga.local_govt
FROM m_client c
JOIN (SELECT
		PARENTKEY,
		"VALUE" local_govt
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858e65582a517e0158404f592c63ec') lga
ON c.external_id = lga.PARENTKEY
on conflict(client_id) do nothing;