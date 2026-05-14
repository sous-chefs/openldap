# frozen_string_literal: true

name              'openldap'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Provides resources to install and configure OpenLDAP slapd.'
version           '7.0.0'
source_url        'https://github.com/sous-chefs/openldap'
issues_url        'https://github.com/sous-chefs/openldap/issues'
chef_version      '>= 15.3'

supports 'almalinux', '>= 8.0'
supports 'amazon', '>= 2023.0'
supports 'debian', '>= 12.0'
supports 'fedora'
supports 'opensuseleap', '>= 15.0'
supports 'oracle', '>= 8.0'
supports 'redhat', '>= 8.0'
supports 'rocky', '>= 8.0'
supports 'ubuntu', '>= 22.04'

depends 'dpkg_autostart'
