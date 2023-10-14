-- Bank Information
INSERT INTO "Bank Information"
SELECT tmp.* FROM (
SELECT 
id,
acc.account_no,
b.bank_name,
accn.account_type,
bvn.bvn,
cib.card_issuing_bank,
cexp.card_expiry::date,
mcp.masked_card_pan,
psu.payment_setup_url,
psp.payment_service_provider,
wid.wallet_account_id,
c.submittedon_date,
c.submittedon_date
FROM m_client c
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS account_no
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a6b840a4202095c0142040f35f148cb') acc
ON c.external_id = acc.PARENTKEY
LEFT JOIN 
	(SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'Access Bank' THEN 69
			WHEN "VALUE" = 'ASO Savings' THEN 70
			WHEN "VALUE" = 'CITI Bank' THEN 71
			WHEN "VALUE" = 'EcoBank' THEN 72
			WHEN "VALUE" = 'Enterprise Bank' THEN 73
			WHEN "VALUE" = 'FCMB' THEN 74
			WHEN "VALUE" = 'Fidelity Bank' THEN 75
			WHEN "VALUE" = 'First Bank' THEN 76
			WHEN "VALUE" = 'GT Bank' THEN 77
			WHEN "VALUE" = 'Heritage Bank' THEN 78
			WHEN "VALUE" = 'JAIZ' THEN 79
			WHEN "VALUE" = 'Keystone Bank' THEN 80
			WHEN "VALUE" = 'Mainstreet Bank' THEN 81
			WHEN "VALUE" = 'Skye Bank' THEN 82
			WHEN "VALUE" = 'Stanbic IBTC' THEN 83
			WHEN "VALUE" = 'Standard Chartered' THEN 84
			WHEN "VALUE" = 'Sterling Bank' THEN 85
			WHEN "VALUE" = 'SunTrust Bank' THEN 86
			WHEN "VALUE" = 'UBA' THEN 87
			WHEN "VALUE" = 'Union Bank' THEN 88
			WHEN "VALUE" = 'Unity Bank' THEN 89
			WHEN "VALUE" = 'Wema Bank' THEN 90
			WHEN "VALUE" = 'Zenith Bank' THEN 91
			WHEN "VALUE" = 'Providus Bank' THEN 92
			ELSE NULL 
		END AS bank_name
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a6b840a4202095c0142041a86085096') b
ON c.external_id = b.PARENTKEY
LEFT JOIN 
	(SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'Current' THEN 93
			WHEN "VALUE" = 'Savings' THEN 94
			WHEN "VALUE" = 'Other' THEN 95
			ELSE NULL 
		END AS account_type
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a1eb5ba49a682300149b332226e4b2c') accn
ON c.external_id = accn.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS bvn
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a36219649e44d120149e6de472a64dd') bvn
ON c.external_id = bvn.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS card_issuing_bank
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f045556eaa4015558c943485621') cib
ON c.external_id = cib.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS card_expiry
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a1333885147f287015149bf30223050') cexp
ON c.external_id = cexp.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS masked_card_pan
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858e645591c24b0155a07e9688007f') mcp
ON c.external_id = mcp.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS payment_setup_url
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858e645591c24b0155a0800ff50100') psu
ON c.external_id = psu.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS payment_service_provider
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858e645591c24b0155a080fc4c014f') psp
ON c.external_id = psp.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS wallet_account_id
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858efb675f0bc50167605c286f7f7a') wid
ON c.external_id = wid.PARENTKEY
) tmp
WHERE tmp.id IS NOT NULL
on conflict (client_id) do nothing;

-- Bank Details end

		