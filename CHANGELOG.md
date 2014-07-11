## Version 2.1.x

* pass through msec time so that kibana can better order events

## Version 2.1.0

* Create a basic apparmor profile for nginx. Local overrides can be placed in
  /etc/apparmor.d/nginx_local for site specific behaviour. The default mode is
  to just complain in the logs but allow the action.

## Version 2.0.1

* Log X-Request-Id header in logs for tracking requests. This will not
  currently be set anywhere.

## Version 2.0.0

* removed elastic search specific template as it's a part of elasticsearch-formula
* when hidden behind loadbalancer save real external ip in logs
* when hidden behind loadbalancer pass through Host:Port (Host = $http_host)

## Version 1.1.1

* Allow the max client_max_body_size parameter to be overridden from a pillar value

## Version 1.1.0

* Added UDP based statsd metric generation of start/restart
* Removed explicit pidfile location definition - should remove nginx race condition wrt restarts

## Version 1.0.3

* Allow to pass arbitrary options to http section w/o a need to overwrite the nginx.conf
* Don't log notice level logs by default

## Version 1.0.2

* Fix the permissions on /var/lib/nginx (default proxy_temp_path)

## Version 1.0.1

* Install nginx-full rather than nginx package

## Version 1.0.0

* Initial checkin

