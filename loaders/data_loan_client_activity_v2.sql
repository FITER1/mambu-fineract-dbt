INSERT INTO "Client Account Activity"
SELECT tmp.* FROM (
SELECT 
id,
td.total_debits::numeric,
tc.total_credit::numeric,
od.opening_date::date,
cd.closing_date::date,
ob.opening_balance::numeric,
cb.closing_balance::numeric,
hb.high_balance::numeric,
l.submittedon_date::date,
l.approvedon_date::date
FROM m_loan l
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS total_debits
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f3e589c40610158b4c3c6da48ab') td
    ON l.external_id = td.PARENTKEY
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS total_credit
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f3e589c40610158b4c579a24945') tc
    ON l.external_id = tc.PARENTKEY
JOIN (SELECT
		PARENTKEY,
		"VALUE" AS opening_date
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f3e589c40610158b4c76eaf49b7') od
    ON l.external_id = td.PARENTKEY

JOIN (SELECT
		PARENTKEY,
		"VALUE" AS closing_date
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f3e589c40610158b4cf043f4d2c') cd
    ON l.external_id = td.PARENTKEY

JOIN (SELECT
		PARENTKEY,
		"VALUE" AS opening_balance
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f3e589c40610158b4e6386654cb') ob
    ON l.external_id = td.PARENTKEY

 JOIN (SELECT
		PARENTKEY,
		"VALUE" AS closing_balance
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f3e589c40610158b4fa44205b39') cb
    ON l.external_id = td.PARENTKEY
    
 JOIN (SELECT
		PARENTKEY,
		"VALUE" AS high_balance
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858eb858b1a6d20158b4fc51757337') hb
    ON l.external_id = td.PARENTKEY )  tmp
on conflict (loan_id) do nothing;
        