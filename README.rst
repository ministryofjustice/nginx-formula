nginx-formula
=============
A set of typical nginx configs that cover 90% use-cases.
I.e. they expect that each app comes with::

    root_dir/500.html
    root_dir/503.html
    root_dir/404.html


templates
---------
inheritance tree::

    vhost-base.conf
    |-- vhost-fpm.conf
    |-- vhost-proxy.conf
    |-- vhost-static.conf
    `-- vhost-unixproxy.conf
        `-- vhost-unicorn.conf



vhost-base.conf/vhost-static.conf
---------------------------------

required variables:
 - appslug
 - root_dir

optional variables:
 - index_doc - if defined becomes the index file (default index.html)
 - server_name - if defined than nginx listens on server_name - think vhost (default '_')
 - autoindex - to enable nginx autoindex (default False)


vhost-fpm.conf
---------------

required:
 - appslug
 - root_dir
 - fastcgienv - a dictionary of variables to pass to fastcgi (as fastcgi_param)

optional:
 - index_doc
 - server_name


vhost-proxy.conf
----------------
required:
 - appslug
 - proxy_to - i.e. localhost:5151

optional:
 - root_dir - defaults to /srv/{{appslug}}
 - index_doc
 - server_name


vhost-unicorn.conf/vhost-unixproxy.conf
---------------------------------------
required:
 - appslug
 - root_dir
 - unix_socket

optional:
 - index_doc
 - server_name


example
-------
pillar::

    nginx:
      port: 80

    apps:
      foo:
        port: 80 (defaults to nginx.port)
        redirects: []
        http_access_rules: []
        external_url: http://www.example.com
        enforce_www: False
        enforce_no_www: False
        auth_basic: True
        auth_basic_user_file: '/etc/supersafe/my_key'
        is_external: False
        client_max_body_size: None

    maintenance:
      enabled: False
      password: changeme

grains::

    provider: vagrant (defaults to ec2)


usage example
-------------
example::

    include:
      - nginx

    /etc/nginx/conf.d/foo.conf:
      file:
        - managed
        - source: salt://nginx/templates/vhost-proxy.conf
        - template: jinja
        - user: root
        - group: root
        - mode: 644
        - context:
            appslug: foo
            server_name: foo.*
            proxy_to: localhost:9876
        - watch_in:
          - service: nginx


Don't forget to manage the logs. I.e. by::

    {% from 'logstsash/lib.sls' import logship with context %}

    {{ logship('foo-access',  '/var/log/nginx/foo.access.json', 'nginx', ['nginx', 'foo', 'access'],  'rawjson') }}
    {{ logship('foo-error',  '/var/log/nginx/foo.error.json', 'nginx', ['nginx', 'foo', 'error'],  'json') }}
