-- Basic Details
INSERT INTO "Basic Details"
SELECT tmp.* FROM (
SELECT 
(SELECT id FROM m_group WHERE external_id = g.ENCODEDKEY) group_id,
mob.mobile_no,
othn.other_no,
e.email,
NULL::integer loan_cycle,
NULL::integer preferred_language,
NULL group_role_key,
g.creationdate,
g.creationdate
FROM final_group g
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS mobile_no
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8abcdeb5488b3dea0148a1e811880284') mob
ON g.ENCODEDKEY = mob.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS other_no
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8abcdeb5488b3dea0148a2372abb2d94') othn
ON g.ENCODEDKEY = othn.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS email
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8abcdeb5488b3dea0148a239c1432f43') e
ON g.ENCODEDKEY = e.PARENTKEY
) tmp
WHERE tmp.group_id IS NOT NULL;

-- Basic Details end

		