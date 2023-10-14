-- Referral Code
INSERT INTO "Referral Code"
SELECT 
id,
rc.referral_code,
ct.rf_count::integer,
rb.referred_by
FROM m_client c
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS referral_code
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a1a195a5102780101510f5138ba4efe') rc
ON c.external_id = rc.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS rf_count
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ee75afc09f4015b009f7a104da8') ct
ON c.external_id = ct.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS referred_by
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ee75afc09f4015b00a0d1244efc') rb
ON c.external_id = rb.PARENTKEY
on conflict(client_id) do nothing;

-- Referral Code end
