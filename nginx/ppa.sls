{% from 'nginx/map.jinja' import nginx with context %}

{% if nginx.install_from_ppa %}

nginx-ppa-keys:
    cmd.run:
      - name: "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C"
      - unless: 'apt-key list  | grep -A1  C300EE8C'
      - require_in:
        - {{ oscodename }}-nginx-deb
{% endif %}

{{ oscodename }}-nginx-deb:
  {%- if nginx.install_from_ppa %}
  pkgrepo.managed:
  {%- else %}
  pkgrepo.absent:
  {%- endif %}
    - humanname: nginx deb repository
    - name: deb http://ppa.launchpad.net/nginx/stable/ubuntu {{ oscodename }} main
    - file:  /etc/apt/sources.list.d/nginx-stable-{{ oscodename }}.list
    - cmd: nginx-ppa-keys
    - require_in:
      - pkg.*


