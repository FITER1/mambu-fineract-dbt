-- Client Account Activity
INSERT INTO "Client Account Activity"
SELECT tmp.* FROM (
SELECT 
(SELECT id FROM m_loan WHERE external_id = l.ENCODEDKEY) loan_id,
lr.reapplied::bit,
lcm.closed_at_migration::bit,
lp.purpose,
rsd.start_date::date,
red.end_date::date,
REPLACE(disb.disbursed_amount, ',', '')::numeric,
ds.disbursement_status,
lc.loan_channel,
di.device_id,
tul.top_up_loan::bit,
rci.referral_client_id,
rc.rebate_code,
ra.rebate_amount::numeric,
apid.application_id,
desa.desired_amount::numeric,
dr.delay_reason,
lca.loan_cashback_amount::numeric,
lcp.loan_cashback_percent::numeric,
dck.disb_channel_key,
mid.merchant_id,
prid.purchase_ref_id,
macc.merchant_account_no,
icz.is_carbon_zero_loan::bit
FROM final_loanaccount l
JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS reapplied
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a6b840a4202095c01420412a1d44ac9') lr
ON l.ENCODEDKEY = lr.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS closed_at_migration
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8af82d3f42103a7a014212ecd7e72237') lcm
ON l.ENCODEDKEY = lcm.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS purpose
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a5ced2443e0bf990143e2e8b407248f') lp
ON l.ENCODEDKEY = lp.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS start_date
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a2898ea4467f87b014469c180447364') rsd
ON l.ENCODEDKEY = rsd.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS end_date
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a2898ea4467f87b014469c20b2073f8') red
ON l.ENCODEDKEY = red.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS disbursed_amount
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a362e6b44cebb590144d5ab865f028c') disb
ON l.ENCODEDKEY = disb.PARENTKEY
LEFT JOIN 
	(SELECT
		PARENTKEY,
		CASE 
			WHEN "VALUE" = 'PENDING' THEN 102
			WHEN "VALUE" = 'IN_PROGRESS' THEN 103
			WHEN "VALUE" = 'FAILED' THEN 104
			WHEN "VALUE" = 'SUCCESS' THEN 105
			WHEN "VALUE" = 'CANCELED' THEN 106
			ELSE NULL 
		END AS disbursement_status
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586df5742ce3901574cca1888641a') ds
ON l.ENCODEDKEY = ds.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS loan_channel
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85871a54a057ca0154c43f8ed90976') lc
ON l.ENCODEDKEY = lc.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS device_id
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85872654ece6b70154f1bc06804194') di
ON l.ENCODEDKEY = di.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS top_up_loan
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85872655169137015516de530102fb') tul
ON l.ENCODEDKEY = tul.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS referral_client_id
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586e559b1c3810159cafd4d1f3465') rci
ON l.ENCODEDKEY = rci.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS rebate_code
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586b95a5bb7e4015a66a2f8e93036') rc
ON l.ENCODEDKEY = rc.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS rebate_amount
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586b95a5bb7e4015a66a2f9103046') ra
ON l.ENCODEDKEY = ra.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS application_id
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586545cd00919015cd04eab1d4797') apid
ON l.ENCODEDKEY = apid.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS desired_amount
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586545cd00919015cd055e71c47fb') desa
ON l.ENCODEDKEY = desa.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS delay_reason
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587516ae44d0c016ae463ee6a30d5') dr
ON l.ENCODEDKEY = dr.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS loan_cashback_amount
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586f36cb37dbd016cb948d90c07d2') lca
ON l.ENCODEDKEY = lca.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS loan_cashback_percent
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586f36cb37dbd016cb97dd5020dc4') lcp
ON l.ENCODEDKEY = lcp.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS disb_channel_key
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586fc6d8cf6b8016d90efdff61b9a') dck
ON l.ENCODEDKEY = dck.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS merchant_id
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586e383719eba01837acc117d3fff') mid
ON l.ENCODEDKEY = mid.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS purchase_ref_id
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586e383719eba01837ad274d54009') prid
ON l.ENCODEDKEY = prid.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS merchant_account_no
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85874385d1bffd0185db1a88d70a26') macc
ON l.ENCODEDKEY = macc.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS is_carbon_zero_loan
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85874385d1bffd0185db26e7f10a66') icz
ON l.ENCODEDKEY = icz.PARENTKEY
 ) tmp
WHERE tmp.loan_id IS NOT NULL;

-- Client Account Activity end

		