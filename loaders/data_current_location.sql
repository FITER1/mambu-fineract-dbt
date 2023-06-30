-- Current Location
INSERT INTO "Current Location"
SELECT 
(SELECT id FROM m_client WHERE external_id = c.ENCODEDKEY)::integer client_id,
loc."location",
lon.longitude,
lat.latitude
FROM final_client c
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS "location"
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a08c1984f8f4464014f97a7efbf3821') loc
ON c.ENCODEDKEY = loc.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS longitude
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a16d97a4e9cc2f3014eabe29c0812ae') lon
ON c.ENCODEDKEY = lon.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS latitude
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8ae518cd4eb16523014eb173bffe000d') lat
ON c.ENCODEDKEY = lat.PARENTKEY;

-- Current Location end

		