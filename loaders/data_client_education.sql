-- Education
INSERT INTO "Education" (client_id, "Level of Education_cd_Level of Education")
SELECT 
(SELECT id FROM m_client WHERE external_id = c.ENCODEDKEY)::integer client_id,
ed.education
FROM final_client c
JOIN 
	(SELECT
		PARENTKEY,
		CASE 
			WHEN "VALUE" = 'Primary' THEN 96
			WHEN "VALUE" = 'Secondary' THEN 97
			WHEN "VALUE" = 'Graduate' THEN 98
			WHEN "VALUE" = 'Post-Graduate' THEN 99
			WHEN "VALUE" = 'Doctorate' THEN 100
			WHEN "VALUE" = 'Other' THEN 101
			ELSE NULL 
		END AS education
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a5ced2443e0bf990143e2cc53c014d1') ed
ON c.ENCODEDKEY = ed.PARENTKEY;

-- Education end

		