-- Client Scores
INSERT INTO "Client Scores"
SELECT 
(SELECT id FROM m_client WHERE external_id = c.ENCODEDKEY)::integer client_id,
cs.scores::integer,
ls.lenddo_scores,
cbs.credit_bureau_score,
cl.credit_limit::numeric,
lp.loyalty_points,
ofs.onefi_score::numeric,
js.jasmine_score::numeric
FROM final_client c
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS scores
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8aab1626499c2c4301499e2a0e6f57b7'
		  AND "VALUE" NOT LIKE '%fg%') cs
ON c.ENCODEDKEY = cs.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS lenddo_scores
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a69e92350133b0a01501929c7b9662d') ls
ON c.ENCODEDKEY = ls.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS credit_bureau_score
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a69e92350133b0a0150192e6734664d') cbs
ON c.ENCODEDKEY = cbs.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS credit_limit
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85864c562cb88c015637bb5f947c70') cl
ON c.ENCODEDKEY = cl.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS loyalty_points
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587c25a1d762c015a1d9d62710b04') lp
ON c.ENCODEDKEY = lp.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS onefi_score
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85872e5cd1117a015cd1fde56e0694') ofs
ON c.ENCODEDKEY = ofs.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS jasmine_score
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586ab5f58ff13015f6dc7825e1435') js
ON c.ENCODEDKEY = js.PARENTKEY;

-- Client Scores end

		