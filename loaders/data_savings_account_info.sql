-- Savings Account Balance
INSERT INTO "Account Balance"
SELECT 
(SELECT id FROM m_savings_account WHERE external_id = sa.ENCODEDKEY) savings_account_id,
auth.auth_holds,
res.reserved_balance::integer,
sa.creationdate,
sa.creationdate
FROM final_wallet sa
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS auth_holds
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858764633c7f9501633f9d30452e7e') auth
ON sa.ENCODEDKEY = auth.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS reserved_balance
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587366362d84b0163695f11093393') res
ON sa.ENCODEDKEY = res.PARENTKEY;

INSERT INTO "Account Balance"
SELECT 
(SELECT id FROM m_savings_account WHERE external_id = sa.ENCODEDKEY) savings_account_id,
auth.auth_holds,
res.reserved_balance::integer,
sa.creationdate,
sa.creationdate
FROM final_investment sa
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS auth_holds
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858764633c7f9501633f9d30452e7e') auth
ON sa.ENCODEDKEY = auth.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS reserved_balance
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587366362d84b0163695f11093393') res
ON sa.ENCODEDKEY = res.PARENTKEY;

-- Savings Account Balance end

		