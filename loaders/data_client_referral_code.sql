-- Referral Code
INSERT INTO "Referral Code"
SELECT 
(SELECT id FROM m_client WHERE external_id = c.ENCODEDKEY)::integer client_id,
rc.referral_code,
ct.rf_count::integer,
rb.referred_by
FROM final_client c
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS referral_code
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85818c5351e123015351e4379f005e') rc
ON c.ENCODEDKEY = rc.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS rf_count
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85868c5ad275c2015ad780a28d0328') ct
ON c.ENCODEDKEY = ct.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS referred_by
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85868c5ad275c2015adb9e90627c94') rb
ON c.ENCODEDKEY = rb.PARENTKEY;

-- Referral Code end