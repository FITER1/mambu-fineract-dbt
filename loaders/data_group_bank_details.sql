-- Basic Details
INSERT INTO "Basic Details"
SELECT tmp.* FROM (
SELECT 
id,
mob.mobile_no,
othn.other_no,
e.email,
NULL::integer loan_cycle,
NULL::integer preferred_language,
NULL group_role_key,
g.submittedon_date,
g.submittedon_date
FROM m_group g
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS mobile_no
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8abcdeb5488b3dea0148a1e811880284') mob
ON g.external_id = mob.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS other_no
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8abcdeb5488b3dea0148a2372abb2d94') othn
ON g.external_id = othn.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS email
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8abcdeb5488b3dea0148a239c1432f43') e
ON g.external_id = e.PARENTKEY
) tmp
WHERE tmp.id IS NOT NULL
on conflict(group_id) do nothing;

-- Basic Details end