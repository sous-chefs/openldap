name              'openldap'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache 2.0'
description       'Configures a server to be an OpenLDAP master, replication slave or client for auth'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '2.2.1'

recipe            'openldap',         'Empty, use one of the other recipes'
recipe            'openldap::server', 'Set up openldap to be a standalone server'
recipe            'openldap::master', 'Sets up openldap as a replication master'
recipe            'openldap::slave',  'Sets up openldap to replicate to a specified master'

%w(ubuntu debian freebsd redhat centos amazon scientific oracle).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/openldap'
issues_url 'https://github.com/chef-cookbooks/openldap/issues'
chef_version '>= 12.1' if respond_to?(:chef_version)
