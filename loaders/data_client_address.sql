-- Client Address
INSERT INTO "Client Address" (client_id, "Client Address Line1", "Client Address Line2",
							 "Client City", "STATE_cd_Client Region", "COUNTRY_cd_Client country", 
							  "Client Postcode", "Client Longitude", "Client Latitude")
SELECT 
id,
add1.address1,
add2.address2,
NULL AS city,
st.state,
247 as country, -- Nigeria
NULL AS postal_code,
lon.longitude,
lat.latitude
FROM m_client c
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS address1
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8abcdeb5488b3dea0148a1d9746b77eb') add1
ON c.external_id = add1.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS address2
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8abcdeb5488b3dea0148a1d9746b77eb') add2
ON c.external_id = add2.PARENTKEY
JOIN 
	(SELECT
		PARENTKEY,
		CASE 
			WHEN "VALUE" ILIKE 'Abuja (FCT)' THEN 247
			WHEN "VALUE" ILIKE 'Abia' THEN 211
			WHEN "VALUE" ILIKE 'Adamawa' THEN 212
			WHEN "VALUE" ILIKE 'Akwa Ibom' THEN 213
			WHEN "VALUE" ILIKE 'Anambra' THEN 214
			WHEN "VALUE" ILIKE 'Bauchi' THEN 215
			WHEN "VALUE" ILIKE 'Bayelsa' THEN 216
			WHEN "VALUE" ILIKE 'Benue' THEN 217
			WHEN "VALUE" ILIKE 'Borno' THEN 218
			WHEN "VALUE" ILIKE 'Cross Rive' THEN 219
			WHEN "VALUE" ILIKE 'Delta' THEN 220
			WHEN "VALUE" ILIKE 'Ebonyi' THEN 221
			WHEN "VALUE" ILIKE 'Edo' THEN 222
			WHEN "VALUE" ILIKE 'Ekiti' THEN 223
			WHEN "VALUE" ILIKE 'Enugu' THEN 224
			WHEN "VALUE" ILIKE 'Gombe' THEN 225
			WHEN "VALUE" ILIKE 'Imo' THEN 226
			WHEN "VALUE" ILIKE 'Jigawa' THEN 227
			WHEN "VALUE" ILIKE 'Kaduna' THEN 228
			WHEN "VALUE" ILIKE 'Kano' THEN 229
			WHEN "VALUE" ILIKE 'Katsina' THEN 230
			WHEN "VALUE" ILIKE 'Kebbi' THEN 231
			WHEN "VALUE" ILIKE 'Kogi' THEN 232
			WHEN "VALUE" ILIKE 'Kwara' THEN 233
			WHEN "VALUE" ILIKE 'Lagos' THEN 234
			WHEN "VALUE" ILIKE 'Nasarawa' THEN 235
			WHEN "VALUE" ILIKE 'Niger' THEN 236
			WHEN "VALUE" ILIKE 'Ogun' THEN 237
			WHEN "VALUE" ILIKE 'Ondo' THEN 238
			WHEN "VALUE" ILIKE 'Osun' THEN 239
			WHEN "VALUE" ILIKE 'Oyo' THEN 240
			WHEN "VALUE" ILIKE 'Plateau' THEN 241
			WHEN "VALUE" ILIKE 'Rivers' THEN 242
			WHEN "VALUE" ILIKE 'Sokoto' THEN 243
			WHEN "VALUE" ILIKE 'Taraba' THEN 244
			WHEN "VALUE" ILIKE 'Yobe' THEN 245
			WHEN "VALUE" ILIKE 'Zamfara' THEN 246
			ELSE NULL 
		END AS state
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8aad33cd46f34dc80146fb73c1b85735') st
ON c.external_id = st.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS latitude
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a18227c4fcc2e39014fdbf7274f1d45') lat
ON c.external_id = lat.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS longitude
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a18227c4fcc2e39014fdbf6d1de1d32') lon
ON c.external_id = lon.PARENTKEY;

-- Client Address end

		