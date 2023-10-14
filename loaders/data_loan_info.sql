-- Additional Loan Information
INSERT INTO "Additional Loan Information"
SELECT tmp.* FROM (
SELECT 
(SELECT id FROM m_loan WHERE external_id = l.external_id) loan_id,
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
FROM m_loan l
JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS reapplied
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a6b840a4202095c01420412a1d44ac9') lr
ON l.external_id = lr.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS closed_at_migration
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8af82d3f42103a7a014212ecd7e72237') lcm
ON l.external_id = lcm.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS purpose
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a5ced2443e0bf990143e2e8b407248f') lp
ON l.external_id = lp.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS start_date
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a2898ea4467f87b014469c180447364') rsd
ON l.external_id = rsd.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS end_date
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a2898ea4467f87b014469c20b2073f8') red
ON l.external_id = red.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS disbursed_amount
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a362e6b44cebb590144d5ab865f028c') disb
ON l.external_id = disb.PARENTKEY
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
	WHERE CUSTOMFIELDKEY = '8a858e845800dfc001580712758c157b') ds
ON l.external_id = ds.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS loan_channel
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85892854be331a0154c3fcf9ee6aee') lc
ON l.external_id = lc.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS device_id
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f1554e294490154f1c2fc040b3f') di
ON l.external_id = di.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS top_up_loan
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858fe55511cbce01551744b99d3b25') tul
ON l.external_id = tul.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS referral_client_id
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858fc959bc56c80159cb06ee767018') rci
ON l.external_id = rci.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS rebate_code
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f0e5a6171ba015a66adb57d1132') rc
ON l.external_id = rc.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS rebate_amount
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f0e5a6171ba015a66aed66e1178') ra
ON l.external_id = ra.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS application_id
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f9f5dd14307015ddb6f8d9029e1') apid
ON l.external_id = apid.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS desired_amount
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f9f5dd14307015ddb714b212a66') desa
ON l.external_id = desa.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS delay_reason
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f926b715531016b715d74f101d3') dr
ON l.external_id = dr.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS loan_cashback_amount
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858eb36cf61a27016cf7a4ef21141b') lca
ON l.external_id = lca.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS loan_cashback_percent
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858eb36cf61a27016cf7a5d857146c') lcp
ON l.external_id = lcp.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS disb_channel_key
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f3a6d90af22016d930c92186924') dck
ON l.external_id = dck.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS merchant_id
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ee88442731f01844e5cc0617c44') mid
ON l.external_id = mid.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS purchase_ref_id
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ee88442731f01844e5e01aa7c9a') prid
ON l.external_id = prid.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS merchant_account_no
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ffe8683c74401868ac9054942c1') macc
ON l.external_id = macc.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS is_carbon_zero_loan
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ffe8683c74401868aca630f43fd') icz
ON l.external_id = icz.PARENTKEY
 ) tmp
on conflict (loan_id) do nothing;

-- Additional Loan Information end

		