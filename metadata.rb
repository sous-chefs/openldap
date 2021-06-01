name              'openldap'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs and configures OpenLDAP (slapd) an open source implementation of LDAP.'
version           '5.0.1'
source_url        'https://github.com/sous-chefs/openldap'
issues_url        'https://github.com/sous-chefs/openldap/issues'
chef_version      '>= 12.15'

supports 'amazon'
supports 'centos'
supports 'debian'
supports 'fedora'
supports 'freebsd'
supports 'opensuse'
supports 'oracle'
supports 'redhat'
supports 'scientific'
supports 'ubuntu'

depends 'dpkg_autostart'
