-- Additional Client Information
INSERT INTO "Additional Client Information"
SELECT 
(SELECT id FROM m_client WHERE external_id = c.ENCODEDKEY) client_id,
r.residential_status,
rt.residence_type,
ms.marital_status,
co.car_owner::bit,
dep.num_dependants::integer,
mon.monthly_recharge_amount::integer,
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
FROM final_client c
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
ON c.ENCODEDKEY = r.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		CASE 
			WHEN "VALUE" = 'Duplex' THEN 50
			WHEN "VALUE" = 'Flats' THEN 51
			WHEN "VALUE" = 'Bungalow' THEN 49
			ELSE NULL 
		END AS residence_type
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a1d158e505b5ebe015060a70d4535f9') rt
ON c.ENCODEDKEY = rt.PARENTKEY
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
ON c.ENCODEDKEY = ms.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		CASE
			WHEN "VALUE" = 'TRUE' THEN 1
		   	WHEN "VALUE" = 'FALSE' THEN 0
		  	ELSE NULL
		END AS car_owner
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a08c1984f8f4464014f97add7c83837') co
ON c.ENCODEDKEY = co.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS num_dependants
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a5ced2443e0bf990143e2dc5f1b20c7') dep
ON c.ENCODEDKEY = dep.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS monthly_recharge_amount
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a08c1984f8f4464014f97b39b0f3856') mon
ON c.ENCODEDKEY = mon.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS no_monthly_recharge
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a08c1984fd74ddf014fdc15a9d12157') no_mon
ON c.ENCODEDKEY = no_mon.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS time_current_address
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a131d0d4c536a09014c568dff9045ae') curr_add
ON c.ENCODEDKEY = curr_add.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS stated_device
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a16f67e50564f0301506b2ccd1d0b00') device
ON c.ENCODEDKEY = device.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS channel
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85871a54a057ca0154c3b665397288') channel
ON c.ENCODEDKEY = channel.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS ip_address
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586d957b44cab0157ba0c244c7231') ip
ON c.ENCODEDKEY = ip.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS device_os
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85860c6a25f24b016a26305f071fc6') dev_os
ON c.ENCODEDKEY = dev_os.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS app_version
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8586b98352bf8e01835566be7a1cae') app
ON c.ENCODEDKEY = app.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS change_status
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a85874a835a69c501835b42bb13084a') dev_cs
ON c.ENCODEDKEY = dev_cs.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS change_date
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a8587f883562f4801835a1b2d0a1bb4') dev_cd
ON c.ENCODEDKEY = dev_cd.PARENTKEY
LEFT JOIN (SELECT
		PARENTKEY,
		"VALUE" AS detected
	FROM customfieldvalue
	WHERE CUSTOMFIELDKEY = '8a69e923501948cc015037d9fd030bcc') dev_det
ON c.ENCODEDKEY = dev_det.PARENTKEY;

-- Additional Client Information end

		