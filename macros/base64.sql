{% macro decode_base64(field) %}
    -- Implementation for PostgreSQL
    convert_from(decode("{{ field }}", 'base64'), 'UTF8')
{% endmacro %}

{% macro encode_base64(field) %}
    -- Implementation for PostgreSQL
    convert_from(encode("{{ field }}", 'base64'), 'UTF8')
{% endmacro %}