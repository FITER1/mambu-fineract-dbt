INSERT INTO m_office (parent_id, hierarchy, external_id, name, opening_date) SELECT CAST(parent_id AS bigint), hierarchy, external_id, name, opening_date FROM m_office_view