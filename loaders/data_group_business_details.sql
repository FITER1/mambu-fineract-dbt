-- Business Details
INSERT INTO "Business Details"
SELECT tmp.* FROM (
SELECT 
(SELECT id FROM m_group WHERE external_id = g.ENCODEDKEY) group_id,
rc.rc_number,
tin.tin,
lga.local_govt_area,
bsd.start_date::date,
NULL::integer opening_hour,
NULL::integer daily_op_hours,
loc.no_of_locations,
ob.owns_business,
NULL::integer fixed_premises,
NULL::integer time_at_main_address,
ss.staff_size,
avgs.average_sales,
sec.sector_served,
NULL::integer business_industry,
kwl.withdrawal_limit::numeric,
kol.overdraft_limit::numeric,
kdl.deposit_limit::numeric,
va.verified_account::bit,
obvn.bvn,
mid.merchant_id,
ocn.onboarding_channel,
g.creationdate,
g.creationdate
FROM final_group g
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS rc_number
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8abcdeb5488b3dea0148a181f35a2957') rc
ON g.ENCODEDKEY = rc.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS tin
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586ef7f6bdf43017f6df133772905') tin
ON g.ENCODEDKEY = tin.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS local_govt_area
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8abcdeb5488b3dea0148a1e6f946021b') lga
ON g.ENCODEDKEY = lga.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS start_date
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586ef7f6bdf43017f6fa591904dbe') bsd
ON g.ENCODEDKEY = bsd.PARENTKEY
LEFT JOIN 
	(SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = '1' THEN 143
			WHEN "VALUE" = '1 - 3' THEN 144
			WHEN "VALUE" = '3 - 10' THEN 145
			WHEN "VALUE" = '10+' THEN 146
			ELSE NULL 
		END AS no_of_locations
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586ef7f6bdf43017f6dfbc2d32971') loc
ON g.ENCODEDKEY = loc.PARENTKEY
LEFT JOIN 
	(SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'Yes' THEN 147
			WHEN "VALUE" = 'No' THEN 148
			ELSE NULL 
		END AS owns_business
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586ef7f6bdf43017f6df1337228ff') ob
ON g.ENCODEDKEY = ob.PARENTKEY
LEFT JOIN 
	(SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = '1 - 20' THEN 154
			WHEN "VALUE" = '21 - 50' THEN 155
			WHEN "VALUE" = '51 - 100' THEN 156
			WHEN "VALUE" = '100+' THEN 157
			ELSE NULL 
		END AS staff_size
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586ef7f6bdf43017f703548495632') ss
ON g.ENCODEDKEY = ss.PARENTKEY
LEFT JOIN 
	(SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = '0 - N1m' THEN 158
			WHEN "VALUE" = 'N1m - N5m' THEN 159
			WHEN "VALUE" = 'N5m - N10m' THEN 160
			WHEN "VALUE" = 'N10m - N50m' THEN 161
			WHEN "VALUE" = 'N50m - N100m' THEN 162
			WHEN "VALUE" = 'N100m+' THEN 163
			ELSE NULL 
		END AS average_sales
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586ef7f6bdf43017f6df870232959') avgs
ON g.ENCODEDKEY = avgs.PARENTKEY
LEFT JOIN 
	(SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'Individual Consumers' THEN 164
			WHEN "VALUE" = 'Business/Companies' THEN 165
			WHEN "VALUE" = 'Government' THEN 166
			ELSE NULL 
		END AS sector_served
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586ef7f6bdf43017f703e619756c1') sec
ON g.ENCODEDKEY = sec.PARENTKEY 
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS withdrawal_limit
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587bb6ae93b0c016afeba63dd7ca5') kwl
ON g.ENCODEDKEY = kwl.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS overdraft_limit
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587bb6ae93b0c016afec1f3067ede') kol
ON g.ENCODEDKEY = kol.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS deposit_limit
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587bb6ae93b0c016afec5b98e7f14') kdl
ON g.ENCODEDKEY = kdl.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS verified_account
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587bb6ae93b0c016afec5b98e7f18') va
ON g.ENCODEDKEY = va.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS bvn
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587bb6ae93b0c016af8cf98bf7054') obvn
ON g.ENCODEDKEY = obvn.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS merchant_id
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587506b566dfd016b652cda572b98') mid
ON g.ENCODEDKEY = mid.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS onboarding_channel
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587ff82d451250182d549cd6d1571') ocn
ON g.ENCODEDKEY = ocn.PARENTKEY 
) tmp
WHERE tmp.group_id IS NOT NULL;

-- Business Details end

		