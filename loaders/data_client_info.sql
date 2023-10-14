-- Additional Client Information
INSERT INTO "Additional Client Information"
SELECT 
id,
r.residential_status,
rt.residence_type,
ms.marital_status,
co.car_owner::bit,
dep.num_dependants::integer,
mon.monthly_recharge_amount::numeric,
no_mon.no_monthly_recharge::integer,
curr_add.time_current_address::integer,
device.stated_device,
channel.channel,
ip.ip_address,
dev_os.device_os,
app.app_version,
dev_cs.change_status,
dev_cd.change_date,
dev_det.detected
FROM m_client c
JOIN 
	(SELECT
		PARENTKEY,
		CASE 
			WHEN "VALUE" = 'Own Residence' THEN 47
			WHEN "VALUE" = 'Rented' THEN 46
			WHEN "VALUE" = 'Family Owned' THEN 45
			WHEN "VALUE" = 'Temp. Residence' THEN 44
			WHEN "VALUE" = 'Employer Provided' THEN 48
			ELSE NULL 
		END AS residential_status
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a5ced2443e0bf990143e2da83e21f89') r
ON c.external_id = r.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		CASE 
			WHEN "VALUE" = 'Duplex' THEN 50
			WHEN "VALUE" = 'Flats' THEN 51
			WHEN "VALUE" = 'Bungalow' THEN 49
			ELSE NULL 
		END AS residence_type
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a28b0cf505fe37b015060b148124847') rt
ON c.external_id = rt.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'Others' THEN 57
			WHEN "VALUE" = 'Single' THEN 52
			WHEN "VALUE" = 'Married' THEN 53
			WHEN "VALUE" = 'Separated' THEN 54
			WHEN "VALUE" = 'Divorced' THEN 55
			WHEN "VALUE" = 'Widowed' THEN 56
			ELSE NULL 
		END AS marital_status
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a5ced2443e0bf990143e2db80bb2031') ms
ON c.external_id = ms.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS car_owner
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a18227c4fcc2e39014fdb3d08b8408c') co
ON c.external_id = co.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS num_dependants
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a5ced2443e0bf990143e2dc5f1b20c7') dep
ON c.external_id = dep.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS monthly_recharge_amount
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a18227c4fcc2e39014fdb4ba611465f') mon
ON c.external_id = mon.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS no_monthly_recharge
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a18227c4fcc2e39014fdbfeeb1e22d8') no_mon
ON c.external_id = no_mon.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS time_current_address
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a131d0d4c536a09014c568dff9045ae') curr_add
ON c.external_id = curr_add.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS stated_device
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a2acf2c506ad74001506bd6c3c84c99') device
ON c.external_id = device.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS channel
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85892854be331a0154c3b3aecb4dd4') channel
ON c.external_id = channel.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS ip_address
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858f7057b918e40157bd5b03f457ab') ip
ON c.external_id = ip.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS device_os
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858eef6a24d26b016a26af686a179d') dev_os
ON c.external_id = dev_os.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS app_version
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ede8365366201837deddfae17f6') app
ON c.external_id = app.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS change_status
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ede8365366201837def63ce1ace') dev_cs
ON c.external_id = dev_cs.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS change_date
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a858ede8365366201837dff0adb3461') dev_cd
ON c.external_id = dev_cd.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS detected
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a69e923501948cc015037d9fd030bcc') dev_det
ON c.external_id = dev_det.PARENTKEY
on conflict(client_id) do nothing;

		


		