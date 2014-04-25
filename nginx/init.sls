{% from "nginx/map.jinja" import nginx, maintenance with context %}

include:
  - bootstrap.groups


nginx-pkg-deps:
  pkg.installed:
    - name: apache2-utils


nginx:
  user:
    - present
    - home: /var/cache/nginx
    - createhome: False
    - shell: /sbin/nologin
    - system: True
    - groups:
      - webservice
      - www-data
    - require:
      - group: webservice
  pkg:
    - name: {{nginx.pkg}}
    - installed
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/conf.d/*.conf


{% from 'firewall/lib.sls' import firewall_enable with context %}
{{ firewall_enable('nginx', nginx.port , 'tcp') }}

/etc/nginx/nginx.conf:
  file:
    - managed
    - source: salt://nginx/templates/nginx.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja


/etc/nginx/conf.d/default.conf:
  file:
    - managed
    - source: salt://nginx/templates/default.conf
    - user: root
    - group: root
    - mode: 644


/etc/nginx/sites-available:
  file:
    - absent


/etc/nginx/sites-enabled:
  file:
    - absent
