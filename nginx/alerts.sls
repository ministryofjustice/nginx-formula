{% from 'sensu/lib.sls' import sensu_check_procs with context %}
{{ sensu_check_procs('nginx') }}
