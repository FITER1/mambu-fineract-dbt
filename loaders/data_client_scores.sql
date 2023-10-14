-- Client Scores
INSERT INTO "Client Scores"
SELECT 
id,
cs.scores::integer,
ls.lenddo_scores,
cbs.credit_bureau_score,
cl.credit_limit::numeric,
lp.loyalty_points,
ofs.onefi_score::numeric,
js.jasmine_score::numeric
FROM m_client c
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS scores
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8aab1626499c2c4301499e2a0e6f57b7'
		  AND "VALUE" NOT LIKE '%fg%') cs
ON c.external_id = cs.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS lenddo_scores
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a132cd150184bef0150193153eb578e') ls
ON c.external_id = ls.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS credit_bureau_score
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a132cd150184bef01501931d35a582d') cbs
ON c.external_id = cbs.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS credit_limit
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858e9b5623763201562d5936521be0') cl
ON c.external_id = cl.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS loyalty_points
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858eda5a1930fd015a1dfb679e3561') lp
ON c.external_id = lp.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS onefi_score
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f585cf9d48b015cffb32c3867ed') ofs
ON c.external_id = ofs.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS jasmine_score
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858fcb5f61e3dc015f6dc5bbc31074') js
ON c.external_id = js.PARENTKEY
on conflict(client_id) do nothing;

-- Client Scores end
