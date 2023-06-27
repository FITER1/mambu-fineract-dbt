-- Basic Info

INSERT INTO "Basic Info"
SELECT 
(SELECT id FROM m_savings_account WHERE external_id = sa.ENCODEDKEY) savings_account_id,
acc.account_name,
sa.creationdate,
sa.creationdate
FROM final_investment sa
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS account_name
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85872e6b4bdf1c016b509ca0c7021e') acc
ON sa.ENCODEDKEY = acc.PARENTKEY;

INSERT INTO "Basic Info"
SELECT 
(SELECT id FROM m_savings_account WHERE external_id = sa.ENCODEDKEY) savings_account_id,
acc.account_name,
sa.creationdate,
sa.creationdate
FROM final_wallet sa
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS account_name
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85872e6b4bdf1c016b509ca0c7021e') acc
ON sa.ENCODEDKEY = acc.PARENTKEY;

-- Basic Info end

		