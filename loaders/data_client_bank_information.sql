-- Bank Information
INSERT INTO "Bank Information"
SELECT tmp.* FROM (
SELECT 
(SELECT id FROM m_client WHERE external_id = c.ENCODEDKEY) client_id,
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
c.creationdate,
c.creationdate
FROM final_client c
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS account_no
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a6b840a4202095c0142040f35f148cb') acc
ON c.ENCODEDKEY = acc.PARENTKEY
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
ON c.ENCODEDKEY = b.PARENTKEY
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
ON c.ENCODEDKEY = accn.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS bvn
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a36219649e44d120149e6de472a64dd') bvn
ON c.ENCODEDKEY = bvn.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS card_issuing_bank
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85863f5558b1c4015558c34dac002d') cib
ON c.ENCODEDKEY = cib.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS card_expiry
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8ae6317d513f33b2015149c009547f03') cexp
ON c.ENCODEDKEY = cexp.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS masked_card_pan
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85863f5558b1c401555939b35e02ea') mcp
ON c.ENCODEDKEY = mcp.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS payment_setup_url
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587b9558aecd6015590d78d970823') psu
ON c.ENCODEDKEY = psu.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS payment_service_provider
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587b75596f0170155978715b713ed') psp
ON c.ENCODEDKEY = psp.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS wallet_account_id
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85864b6584fe96016585da9ba8389d') wid
ON c.ENCODEDKEY = wid.PARENTKEY
) tmp
WHERE tmp.client_id IS NOT NULL;

-- Bank Details end

		