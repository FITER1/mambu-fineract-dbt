-- Social Media Information
INSERT INTO "Social Media Information"
SELECT 
(SELECT id FROM m_client WHERE external_id = c.ENCODEDKEY)::integer client_id,
fa.fb_auth::bit,
fb.fb_url,
fbi.fbid,
fbt.fb_update_time::date
FROM final_client c
JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS fb_auth
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a16d97a4e9cc2f3014eabe01c8f12aa') fa
ON c.ENCODEDKEY = fa.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS fb_url
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a08c1984f8f4464014f975d10c636f8') fb
ON c.ENCODEDKEY = fb.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS fbid
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a08c1984f8f4464014f975dafa736fd') fbi
ON c.ENCODEDKEY = fbi.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS fb_update_time
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a08c1984f8f4464014f97a4ac3f3815') fbt
ON c.ENCODEDKEY = fbt.PARENTKEY;

-- Social Media Information end