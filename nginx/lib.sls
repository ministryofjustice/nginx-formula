
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
