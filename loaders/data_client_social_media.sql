-- Social Media Information
INSERT INTO "Social Media Information"
SELECT 
id,
fa.fb_auth::bit,
fb.fb_url,
fbi.fbid,
fbt.fb_update_time::date
FROM m_client c
JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS fb_auth
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a18227c4fcc2e39014fdbe5f8660f30') fa
ON c.external_id = fa.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS fb_url
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a18227c4fcc2e39014fdbe6dd090fee') fb
ON c.external_id = fb.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS fbid
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a18227c4fcc2e39014fdbe784821079') fbi
ON c.external_id = fbi.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS fb_update_time
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a18227c4fcc2e39014fdbe81d451119') fbt
ON c.external_id = fbt.PARENTKEY
on conflict(client_id) do nothing;

-- Social Media Information end