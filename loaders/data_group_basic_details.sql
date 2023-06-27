-- Business Details
INSERT INTO "Business Details"
SELECT tmp.* FROM (
SELECT 
(SELECT id FROM m_group WHERE external_id = g.ENCODEDKEY) group_id,
b.bank_name,
acc.account_no,
accn.account_name,
bvnc.bvn_corporate,
opd.opening_date::date,
g.creationdate,
g.creationdate
FROM final_group g
JOIN 
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
	WHERE CUSTOMFIELDKEY = '8a9c53ea48f8a9eb0148f9df6ffb251e') b
ON g.ENCODEDKEY = b.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS account_no
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a9c53ea48f8a9eb0148f9dff1412553') acc
ON g.ENCODEDKEY = acc.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS account_name
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a9c53ea48f8a9eb0148f9e0354625c5') accn
ON g.ENCODEDKEY = accn.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS bvn_corporate
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586ef7f6bdf43017f70669b1c5906') bvnc
ON g.ENCODEDKEY = bvnc.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS opening_date
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a9c53ea48f8a9eb0148f9e13534263f') opd
ON g.ENCODEDKEY = opd.PARENTKEY
) tmp
WHERE tmp.group_id IS NOT NULL;

-- Business Details end

		