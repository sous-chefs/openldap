name              'openldap'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache-2.0'
description       'Installs and configures OpenLDAP (slapd) an open source implementation of LDAP.'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '3.0.3'

recipe            'openldap::default', 'Install and configure OpenLDAP'

%w(ubuntu debian freebsd redhat centos scientific oracle opensuse).each do |os|
  supports os
end

depends 'dpkg_autostart'

source_url 'https://github.com/chef-cookbooks/openldap'
issues_url 'https://github.com/chef-cookbooks/openldap/issues'
chef_version '>= 12.1' if respond_to?(:chef_version)
