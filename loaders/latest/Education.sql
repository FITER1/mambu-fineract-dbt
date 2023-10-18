INSERT INTO public."Education" (
	client_id,
	"Level of Education_cd_Level of Education",
	created_at,
	updated_at,
	"Classmate1",
	"Classmate2",
	"Subject Studied",
	"Last Educational Institution Attended",
	"Year of Completion"
)
SELECT 
	m_client.id AS client_id,
	m_code_value.id AS "Level of Education_cd_Level of Education",
	m_client.submittedon_date AS created_at,
	m_client.submittedon_date AS updated_at,
	cf1."VALUE" AS "Classmate1",
	cf2."VALUE" AS "Classmate2",
	cf3."VALUE" AS "Subject Studied",
	cf4."VALUE" AS "Last Educational Institution Attended",
	cf5."VALUE" AS "Year of Completion"
FROM 
	m_client
	LEFT JOIN customfieldvalue cf ON m_client.external_id = cf.parentkey
	LEFT JOIN customfieldvalue cf1 ON m_client.external_id = cf1.parentkey AND cf1.customfieldkey = '8a18227c4fcc2e39014fdb512be94945'
	LEFT JOIN customfieldvalue cf2 ON m_client.external_id = cf2.parentkey AND cf2.customfieldkey = '8a18227c4fcc2e39014fdb52df084a00'
	LEFT JOIN customfieldvalue cf3 ON m_client.external_id = cf3.parentkey AND cf3.customfieldkey = '8a18227c4fcc2e39014fdbd18937031d'
	LEFT JOIN customfieldvalue cf4 ON m_client.external_id = cf4.parentkey AND cf4.customfieldkey = '8a5ced2443e0bf990143e2d259b81a71'
	LEFT JOIN customfieldvalue cf5 ON m_client.external_id = cf5.parentkey AND cf5.customfieldkey = '8a6a80714f1c6f97014f2253458d2614'
	LEFT JOIN m_code_value ON LOWER(m_code_value.code_value) = LOWER(cf."VALUE") AND m_code_value.code_id = 56
WHERE 
	cf.customfieldkey = '8a5ced2443e0bf990143e2cc53c014d1'
    on conflict (client_id) do nothing;
