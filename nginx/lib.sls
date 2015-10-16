
{#
TODO: Make it work with map_app.jinja
#}

{% macro nginx_basic_auth(appslug) %}

/etc/nginx/htpasswd-{{appslug}}:
  file.managed


{% for username, password in salt['pillar.get']('apps:'+appslug+":nginx:auth_basic_users",{}).iteritems() %}

htpasswd -bd /etc/nginx/htpasswd-{{appslug}} {{username}} {{password}}:
  cmd.run

{#
{{username}}:
  htpasswd.user_exists:
    - password: {{ password }}
    - htpasswd_file: /etc/nginx/htpasswd-{{appslug}}
    - options: d
    - force: true
#}

{% endfor %}

{% endmacro %}

{#
  Log config can be referenced in several places, so let's make it DRY with a macro
#}
{% macro nginx_custom_log_formats_and_files(config) %}
  {% if config.get('logs', False) %}
    {% set log_config = config.get('logs') %}
    {% for format_name, format_json in log_config.get('formats', {}) %}log_format {{ format_name }} '{{ format_json }}';{% endfor %}

    {% for log_params in log_config.get('access_logs', []) %}access_log {{ log_params.path }} {{ log_params.format }}{% endfor %}
    {% for log_params in log_config.get('error_logs', []) %}access_log {{ log_params.path }} {{ log_params.format }}{% endfor %}
  {% endif %}

{% endmacro %}