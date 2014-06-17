{% from "nginx/map.jinja" import nginx, maintenance with context %}

include:
  - bootstrap.groups
  - apparmor


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
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/conf.d/*.conf

/etc/apparmor.d/usr.sbin.nginx:
  file.managed:
    - source: salt://nginx/files/nginx_apparmor_profile
    - template: 'jinja'
    - watch_in:
      - command: reload-profiles
      - service: nginx
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

{% from 'firewall/lib.sls' import firewall_enable with context %}
{{ firewall_enable('nginx', nginx.port , 'tcp') }}

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/templates/nginx.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja


/etc/nginx/conf.d/default.conf:
  file.managed:
    - source: salt://nginx/templates/default.conf
    - user: root
    - group: root
    - mode: 644


/var/lib/nginx:
  file.directory:
    - mode: 700
    - user: nginx
    - group: nginx
    - recurse:
      - user
      - group
      - mode


/etc/nginx/sites-available:
  file.absent


/etc/nginx/sites-enabled:
  file.absent
