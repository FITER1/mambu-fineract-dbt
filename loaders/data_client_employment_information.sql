-- Employment Information
INSERT INTO "Employment Information"
SELECT 
(SELECT id FROM m_client WHERE external_id = c.ENCODEDKEY)::integer client_id,
emp.emp_status,
e.employer,
dt.date_of_emp::date,
np.net_pay::numeric,
pd.pay_date::date,
st.emp_state,
nm.business_name,
bsd.start_date
FROM final_client c
JOIN 
	(SELECT
		PARENTKEY,
		CASE 
			WHEN "VALUE" = 'Permanent' THEN 302
			WHEN "VALUE" = 'Contract' THEN 303
			ELSE NULL 
		END AS emp_status
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a5ced2443e0bf990143e2bbdaf70642') emp
ON c.ENCODEDKEY = emp.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS employer
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a6b840a4202095c0142040cffca4752') e
ON c.ENCODEDKEY = e.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS date_of_emp
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8afacb4d42b1eece0142b278f66c12a8') dt
ON c.ENCODEDKEY = dt.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		REGEXP_REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE("VALUE", ',', ''), ' ', ''), '17905.223017.23', '17905.23'), '`', ''), '#', ''), '"', NULL), '\D+', '') AS net_pay
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a6b840a4202095c0142040e597247cb') np
ON c.ENCODEDKEY = np.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS pay_date
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a5ced2443e0bf990143e2e6191b23d6') pd
ON c.ENCODEDKEY = pd.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS emp_state
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8aad33cd46f34dc80146fb73c1b85735') st
ON c.ENCODEDKEY = st.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS business_name
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a69f7824f01fc60014f225d9f5b3ae7') nm
ON c.ENCODEDKEY = nm.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS start_date
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a6e8ae150676ffa0150712ea93a1f02') bsd
ON c.ENCODEDKEY = bsd.PARENTKEY;

-- Employment Information end

		