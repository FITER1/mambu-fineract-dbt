-- Current Location
INSERT INTO "Current Location"
SELECT 
id,
loc."location",
lon.longitude,
lat.latitude
FROM m_client c
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS "location"
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a18227c4fcc2e39014fdbf777cb1deb') loc
ON c.external_id = loc.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS longitude
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a18227c4fcc2e39014fdbf6d1de1d32') lon
ON c.external_id = lon.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS latitude
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a18227c4fcc2e39014fdbf7274f1d45') lat
ON c.external_id = lat.PARENTKEY
on conflict(client_id) do nothing;

-- Current Location end