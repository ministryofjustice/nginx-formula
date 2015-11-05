
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
  # This macro generates log format & log file config, allowing customisation of both
  #
  # Args:
  #   config(dictionary): a dictionary of additional/replacement log formats and locations, in this form:
  #     { 
  #         formats:
  #           format_name: 'format definition (e.g. a block of json)'
  #         access_logs:
  #           - format: (format name)
  #             path: (absolute path to the log file)
  #           .... repeat the above two lines for as many files as needed
  #         error_logs:
  #           - (as for access_logs)
  #     } 
  #}
{% macro nginx_custom_log_formats_and_files(log_config) %}
  {% for format_name, format_json in log_config.get('formats', {}).iteritems() %}log_format {{ format_name }} '{{ format_json }}';
  {% endfor %}

  {% for log_params in log_config.get('access_logs', []) %}access_log {{ log_params.path }} {{ log_params.format }};
  {% endfor %}
  {% for log_params in log_config.get('error_logs', []) %}access_log {{ log_params.path }} {{ log_params.format }};
  {% endfor %}
{% endmacro %}