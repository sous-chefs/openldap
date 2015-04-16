name              'openldap'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache 2.0'
description       'Configures a server to be an OpenLDAP master, replication slave or client for auth'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '2.2.0'
recipe            'openldap', 'Empty, use one of the other recipes'
recipe            'openldap::auth', 'Set up openldap for user authentication'
recipe            'openldap::client', 'Install openldap client packages'
recipe            'openldap::server', 'Set up openldap to be a slapd server'
recipe            'openldap::slave', 'uses search to set replication slave attributes'
recipe            'openldap::master', 'use on nodes that should be a slapd master'

%w(ubuntu debian freebsd redhat centos amazon scientific oracle).each do |os|
  supports os
end

%w(openssh nscd openssl freebsd).each do |cb|
  depends cb
end
