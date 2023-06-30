-- Fast Track
INSERT INTO "Fast Track"
SELECT 
(SELECT id FROM m_client WHERE external_id = c.ENCODEDKEY)::integer client_id,
ft.fast_tracked::bit
FROM final_client c
JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS fast_tracked
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a9d30644cd5b18d014cd6c662ca78dd') ft
ON c.ENCODEDKEY = ft.PARENTKEY;

-- Fast Track end