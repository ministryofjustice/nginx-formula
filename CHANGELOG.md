## UNRELEASED
* Make the change of init script optional, as it breaks in later versions

## v3.4.0
* Check the nginx config explicitly

## v3.3.4

Fixes:
* double-quoted json in custom log formats

## v3.3.3

Fixes:
* "unknown log format 'error'" when overriding default log formats

## v3.3.2

Fixes:
* "too many items to unpack" error when a custom log format is defined in nginx > logs > formats

## v3.3.0

Features:
* Added ability to provide a custom log_format
* multiple log file/format support in nginx.conf & vhost-base.conf

Fixes:
* Missing import in vhost-base
* Fix nginx log macro calls
* Updated the README to reflect some recent findings
* added explanatory comment in lib.sls
* removed the if statement, which is now redundant as we pass in the contents of the log key rather than its parent
* restructured after consultation with @niallcreech to be compatible with per-host setttings in moj-docker-deploy
* reworked to allow default logstash_json to be kept if wanted
    
## Version 3.2.7
* 3 nginx.conf parameters can be customised via pillar
  * client_max_body_size
  * worker_rlimit_nofile
  * worker_connections

## Version 3.2.4
* opgops-938 - Unpinned the version of nginx.

## Version 3.2.3
* Add optional skip_verify with a sensible default (False) set via nginx.pkg_skip_verify.

## Version 3.2.2
* New version of nginx: 1.4.6-1ubuntu3.2

## Version 3.2.1
* Pin the version of nginx. Can be overwritten in the pillar.

## Version 3.2.0

* add nginx.readable_doc_dir_globs pillar to allow apparmor static asset serving.
* use date based file extensions in logrotate
* ensure we rotate json log files
* change to daily log rotation
* fix logging perms, was causing rotate failures

## Version 3.1.0

* Log key SSL env details: ssl_version, ssl_session_id, et al.

## Version 3.0.0

* Removed code handling enforce_www, enforce_no_www. This should be handled
  on the border, and the code in nginx-base* was insecure.

## Version 2.3.0

* Enable maintenance/503 page from grains in addition to pillar value

## Version 2.2.0

* pass through msec time so that kibana can better order events
* add firewall to includes so that formula compiles

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

