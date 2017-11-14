{% from "nginx/map.jinja" import nginx, maintenance with context %}

include:
  - bootstrap.groups
  - apparmor
  - firewall


nginx-pkg-deps:
  pkg.installed:
    - name: apache2-utils


# This version of netcat seems more reliable
nginx-deps-netcat-traditional:
  pkg.installed:
    - name: netcat-traditional


nginx:
  user.present:
    - home: /var/cache/nginx
    - createhome: False
    - shell: /sbin/nologin
    - system: True
    - groups:
      - webservice
      - www-data
    - require:
      - group: webservice
  pkg.installed:
    - name: {{nginx.pkg}}
    - version: {{nginx.version}}
    - skip_verify: {{ nginx.pkg_skip_verify }}
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/conf.d/*.conf

 nginx-config-test:
   cmd.run:
    - name: 'nginx -t'
    - watch:
      - file: /etc/nginx/conf.d/*.conf

/var/log/nginx:
  file.directory:
    - mode: 2750
    - user: nginx
    - group: adm
    - require:
      - user: nginx

/etc/apparmor.d/nginx_local:
  file.directory:
    - mode: 755
    - user: root
    - group: root

/etc/apparmor.d/usr.sbin.nginx:
  file.managed:
    - source: salt://nginx/templates/nginx_apparmor_profile
    - template: jinja
    - watch_in:
      - service: nginx



{% if nginx.get('override_init', False) %}
#
# Place the startup script under nginx control
# This allows us to generate UDP start events
#
/etc/init.d/nginx:
  file.managed:
    - source: salt://nginx/files/nginx-init
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - require:
      - pkg: nginx
      - pkg: nginx-deps-netcat-traditional
    - watch_in:
      - service: nginx
{% endif %}

{% from 'firewall/lib.sls' import firewall_enable with context %}
{{ firewall_enable('nginx', nginx.port , 'tcp') }}

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/templates/nginx.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require_in:
      - cmd: nginx-config-test


/etc/nginx/conf.d/default.conf:
  file.managed:
    - source: salt://nginx/templates/default.conf
    - user: root
    - group: root
    - mode: 644
    - require_in:
      - cmd: nginx-config-test


/var/lib/nginx:
  file.directory:
    - mode: 700
    - user: nginx
    - group: nginx
    - recurse:
      - user
      - group
      - mode

/etc/logrotate.d/nginx:
  file.managed:
    - source: salt://nginx/templates/logrotate.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root

remove-sites-available:
  file.absent:
    - name: /etc/nginx/sites-available
    - require_in:
      - cmd: nginx-config-test

/etc/nginx/sites-enabled:
  file.absent
