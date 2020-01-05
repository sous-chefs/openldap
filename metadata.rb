name              'openldap'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache-2.0'
description       'Installs and configures OpenLDAP (slapd) an open source implementation of LDAP.'
version           '4.0.0'

%w(ubuntu debian freebsd redhat centos scientific oracle opensuse).each do |os|
  supports os
end

depends 'dpkg_autostart'

source_url 'https://github.com/chef-cookbooks/openldap'
issues_url 'https://github.com/chef-cookbooks/openldap/issues'
chef_version '>= 12.15'
