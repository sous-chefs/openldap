name              'openldap'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache 2.0'
description       'Configures a server to be an OpenLDAP master, replication slave or client for auth'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '2.2.1'

recipe            'openldap',         'Empty, use one of the other recipes'
recipe            'openldap::auth',   'Set up openldap for user authentication'
recipe            'openldap::client', 'Install openldap client packages'
recipe            'openldap::server', 'Set up openldap to be a slapd server'
recipe            'openldap::slave',  'Uses search to set replication slave attributes'
recipe            'openldap::master', 'Use on nodes that should be a slapd master'

%w(ubuntu debian freebsd redhat centos amazon scientific oracle).each do |os|
  supports os
end

depends 'openssl'
depends 'freebsd'

source_url 'https://github.com/chef-cookbooks/openldap' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/openldap/issues' if respond_to?(:issues_url)

attribute 'openldap/server_uri',
          display_name: 'OpenLDAP Server URI',
          description: 'The URI of the LDAP server.',
          required: 'optional'

attribute 'openldap/basedn',
          display_name: 'OpenLDAP Base DN',
          description: 'The Base DN.',
          required: 'optional',
          default: 'dc=localdomain'

attribute 'openldap/cn',
          display_name: 'OpenLDAP CN',
          description: 'The CN.',
          required: 'optional',
          default: 'admin'

attribute 'openldap/server',
          display_name: 'OpenLDAP Server',
          description: "The LDAP server fully qualified domain name, default `'ldap'.node['domain']'.",
          required: 'optional',
          default: 'ldap.localdomain'

attribute 'openldap/port',
          display_name: 'OpenLDAP Server Port',
          description: 'The LDAP server port.',
          required: 'optional',
          default: '389'

attribute 'openldap/tls_checkpeer',
          display_name: 'OpenLDAP TLS Check Peer',
          description: "Specifies whether the client should verify the server's TLS certificate. Highly recommended to set tls_checkpeer to true for production uses in order to avoid man-in-the-middle attacks. Defaults to false for testing and backwards compatibility.",
          required: 'optional'

attribute 'openldap/pam_password',
          display_name: 'OpenLDAP PAM Password',
          description: 'Specifies the password change protocol to use. Defaults to md5.',
          default: 'md5',
          required: 'optional'

attribute 'openldap/tls_enabled',
          display_name: 'OpenLDAP TLS Enabled',
          description: 'Specifies whether TLS will be used at all. Setting this to fals will result in your credentials being sent in clear-text.',
          required: 'optional',
          default: 'true'

attribute 'openldap/schemes',
          display_name: 'OpenLDAP Schemes',
          description: 'Array of ldap schema file names to load.',
          required: 'optional',
          type: 'array'

attribute 'openldap/modules',
          display_name: 'OpenLDAP Modules',
          description: 'Array of slapd modules names to load.',
          required: 'optional',
          type: 'array'

attribute 'openldap/database',
          display_name: 'OpenLDAP Database',
          description: 'Preferred database backend, defaults to HDB or MDB (for FreeBSD).',
          required: 'optional',
          default: 'HDB'

attribute 'openldap/manage_ssl',
          display_name: 'OpenLDAP Manage SSL',
          description: "Whether or not this cookbook manages your SSL certificates. If set to true, this cookbook will expect your SSL certificates to be in files/default/ssl and will configure slapd appropriately. If set to false, you will need to provide your SSL certificates prior to this recipe being run. Be sure to set openldap['ssl_cert'] and openldap['ssl_key'] appropriately.",
          required: 'optional',
          default: 'false'

attribute 'openldap/ssl_cert',
          display_name: 'OpenLDAP SSL Certificate',
          description: 'The full path to your SSL certificate.',
          required: 'optional'

attribute 'openldap/ssl_key',
          display_name: 'OpenLDAP SSL Key',
          description: 'The full path to your SSL key.',
          required: 'optional'

attribute 'openldap/ssl_cert_source_cookbook',
          display_name: 'OpenLDAP SSL Certificate Source Cookbook',
          description: 'The cookbook to find the ssl cert. Defaults to this cookbook.',
          required: 'optional'

attribute 'openldap/ssl_cert_source_path',
          display_name: 'OpenLDAP SSL Certificate Source Path',
          description: 'The path in the cookbook to find the ssl cert file.',
          required: 'optional'

attribute 'openldap/ssl_key_source_cookbook',
          display_name: 'OpenLDAP SSL Key Source Cookbook',
          description: 'The cookbook to find the ssl key. Defaults to this cookbook.',
          required: 'optional'

attribute 'openldap/ssl_key_source_path',
          display_name: 'OpenLDAP SSL Key Source Path',
          description: 'The path in the cookbook to find the ssl key file.',
          required: 'optional'

attribute 'openldap/cafile',
          display_name: 'OpenLDAP CA File',
          description: "Your certificate authority's certificate (or intermediate authorities), if needed.",
          required: 'optional'

attribute 'openldap/rootpw',
          display_name: 'OpenLDAP Root DN Password',
          description: 'The root DN password',
          required: 'required'

attribute 'openldap/nss_base',
          display_name: 'nss_base config',
          description: 'nss_base configuration for pam_ldap',
          required: 'optional'
