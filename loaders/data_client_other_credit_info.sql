-- Other Credit Information
INSERT INTO "Other Credit Information"
SELECT 
id,
hl.has_current_loan::bit,
dsr.debt_service_ratio::numeric,
l.loan_reflected_in_statement::numeric,
ol.other_loans_no_reflected_in_statement::numeric,
cp.credit_report_available::bit,
mr.monthly_report::numeric
FROM m_client c
JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS has_current_loan
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a1a0ff8506bd3570150717a15c30421') hl
ON c.external_id = hl.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" debt_service_ratio
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8abcc1a44bcd8606014be56a346f0cda') dsr
ON c.external_id = dsr.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" loan_reflected_in_statement
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a5ced2443e0bf990143e2c0f2000b0b') l
ON c.external_id = l.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" other_loans_no_reflected_in_statement
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a5ced2443e0bf990143e2c2301c0bd3') ol
ON c.external_id = ol.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS credit_report_available
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a131d0d4c536a09014c567a667b3918') cp
ON c.external_id = cp.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" monthly_report
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a5ced2443e0bf990143e2c2fdb20cb2') mr
ON c.external_id = mr.PARENTKEY
on conflict(client_id) do nothing;

-- Other Credit Information end
