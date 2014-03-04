include:
  - monitoring.logs.beaver


{% from 'monitoring/logs/lib.sls' import logship2 with context %}
{{ logship2('nginx-access', '/var/log/nginx/access.json', 'nginx', ['nginx', 'access'], 'rawjson') }}
{{ logship2('nginx-error',  '/var/log/nginx/error.log', 'nginx', ['nginx', 'error'], 'json') }}
