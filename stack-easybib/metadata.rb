name              'stack-easybib'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'API roles'
version           '0.3'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'haproxy'
depends 'ies'
depends 'ies-mysql'
depends 'nginx-app'
depends 'memcache'
depends 'monit'
depends 'ies-nodejs'
depends 'nodejs'
depends 'ohai'
depends 'pecl-manager'
depends 'php'
depends 'php-fpm'
depends 'postfix'
depends 'redis'
depends 'stack-service'
depends 'fake-sqs'
depends 'supervisor'
depends 'ies-ssl'
depends 'wt-data'
