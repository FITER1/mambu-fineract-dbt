INSERT INTO "Account Balance"
SELECT 
id,
auth.auth_holds,
res.reserved_balance::numeric,
sa.submittedon_date::date,
sa.submittedon_date::date
FROM m_savings_account sa
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS auth_holds
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f5d776c1bd9017782d25b96418a') auth
ON sa.external_id = auth.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS reserved_balance
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f5d776c1bd9017782d2edb842d5') res
ON sa.external_id = res.PARENTKEY
on conflict(savings_account_id) do nothing;