-- Business Details
INSERT INTO "Business Details"
SELECT tmp.* FROM (
SELECT 
id,
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
g.submittedon_date,
g.submittedon_date
FROM m_group g
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS rc_number
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8abcdeb5488b3dea0148a181f35a2957') rc
ON g.external_id = rc.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS tin
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8188a852ab5a620152b223f4ff1e27') tin
ON g.external_id = tin.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS local_govt_area
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8abcdeb5488b3dea0148a1e6f946021b') lga
ON g.external_id = lga.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS start_date
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8abcdeb5488b3dea0148a17a41862757') bsd
ON g.external_id = bsd.PARENTKEY
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
	WHERE CUSTOMFIELDKEY = '8a8188a852ab5a620152b242857e2673') loc
ON g.external_id = loc.PARENTKEY
LEFT JOIN 
	(SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'Yes' THEN 147
			WHEN "VALUE" = 'No' THEN 148
			ELSE NULL 
		END AS owns_business
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8188a852ab5a620152b2441f8826cc') ob
ON g.external_id = ob.PARENTKEY
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
	WHERE CUSTOMFIELDKEY = '8a8188a852ab5a620152b2499311279b') ss
ON g.external_id = ss.PARENTKEY
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
	WHERE CUSTOMFIELDKEY = '8a8188a852ab5a620152b251f6b82920') avgs
ON g.external_id = avgs.PARENTKEY
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
	WHERE CUSTOMFIELDKEY = '8a8188a852ab5a620152b24c3e5a281c') sec
ON g.external_id = sec.PARENTKEY 
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS withdrawal_limit
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ef16b4d8e0c016b5112a8662451') kwl
ON g.external_id = kwl.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS overdraft_limit
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ef16b4d8e0c016b5113d84b2477') kol
ON g.external_id = kol.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS deposit_limit
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ef16b4d8e0c016b5117aaac25a2') kdl
ON g.external_id = kdl.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS verified_account
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ef16b4d8e0c016b511acf9d2630') va
ON g.external_id = va.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS bvn
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ef16b4d8e0c016b511e72d5268f') obvn
ON g.external_id = obvn.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS merchant_id
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ef36b63f9fd016b653e98270137') mid
ON g.external_id = mid.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS onboarding_channel
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858eb38388f8ea01838d784f3d5292') ocn
ON g.external_id = ocn.PARENTKEY 
) tmp
WHERE tmp.id IS NOT NULL
on conflict(group_id) do nothing;

-- Business Details end
