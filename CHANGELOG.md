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

