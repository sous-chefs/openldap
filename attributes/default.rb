# Cookbook Name:: openldap
# Attributes:: default
#
# Copyright 2008-2015, Chef Software, Inc.
# Copyright 2015, Tim Smith <tim@cozy.co>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# per platform settings (generally not overwritten by the user)
#

# File and directory locations for openldap.
case node['platform_family']
when 'rhel'
  default['openldap']['dir'] = '/etc/openldap'
  default['openldap']['run_dir'] = '/var/run/openldap'
  default['openldap']['db_dir'] = '/var/lib/ldap'
  default['openldap']['module_dir'] = '/usr/lib64/openldap'
  default['openldap']['system_acct'] = 'ldap'
  default['openldap']['system_group'] = 'ldap'
when 'debian'
  default['openldap']['dir'] = '/etc/ldap'
  default['openldap']['run_dir'] = '/var/run/slapd'
  default['openldap']['db_dir'] = '/var/lib/ldap'
  default['openldap']['module_dir'] = '/usr/lib/ldap'
  default['openldap']['system_acct'] = 'openldap'
  default['openldap']['system_group'] = 'openldap'
when 'freebsd'
  default['openldap']['dir'] = '/usr/local/etc/openldap'
  default['openldap']['run_dir'] = '/var/run/openldap'
  default['openldap']['db_dir'] = '/var/db/openldap-data'
  default['openldap']['module_dir'] = '/usr/local/libexec/openldap'
  default['openldap']['system_acct'] = 'ldap'
  default['openldap']['system_group'] = 'ldap'
else
  default['openldap']['dir'] = '/etc/ldap'
  default['openldap']['run_dir'] = '/var/run/slapd'
  default['openldap']['module_dir'] = '/usr/lib/ldap'
  default['openldap']['db_dir'] = '/var/lib/ldap'
  default['openldap']['system_acct'] = 'openldap'
  default['openldap']['system_group'] = 'openldap'
end

# backing database
case node['platform_family']
when 'freebsd'
  default['openldap']['modules'] = %w(back_mdb)
  default['openldap']['database'] = 'mdb'
else
  default['openldap']['modules'] = %w(back_hdb)
  default['openldap']['database'] = 'hdb'
end

# packages
case node['platform_family']
when 'debian'
  # precise and up and wheezy and up stopped putting the version name in the db-util package.
  # this is required to keep support for lucid
  default['openldap']['packages']['bdb'] = if node['platform'] == 'ubuntu' && node['platform_version'].to_i < 12
                                             'db4.8-util'
                                           else
                                             'db-util'
                                           end
  default['openldap']['packages']['client_pkg'] = 'ldap-utils'
  default['openldap']['packages']['srv_pkg'] = 'slapd'
  default['openldap']['packages']['auth_pkgs'] = %w(libnss-ldap libpam-ldap)
when 'rhel'
  default['openldap']['packages']['bdb'] = 'db4-utils'
  default['openldap']['packages']['client_pkg'] = 'openldap-clients'
  default['openldap']['packages']['srv_pkg'] = 'openldap-servers'
  default['openldap']['packages']['auth_pkgs'] = %w(nss-pam-ldapd)
when 'freebsd'
  default['openldap']['packages']['bdb'] = 'libdbi'
  default['openldap']['packages']['client_pkg'] = 'openldap-client'
  default['openldap']['packages']['srv_pkg'] = 'openldap-server'
  default['openldap']['packages']['auth_pkgs'] = %w(pam_ldap)
else
  default['openldap']['packages']['bdb'] = 'db-utils'
  default['openldap']['packages']['client_pkg'] = 'ldap-utils'
  default['openldap']['packages']['srv_pkg'] = 'slapd'
  default['openldap']['packages']['auth_pkgs'] = %w(libnss-ldap libpam-ldap)
end

#
# openldap configuration attributes (generally overwritten by the user)
#

default['openldap']['basedn'] = 'dc=localdomain'
default['openldap']['cn'] = 'admin'
default['openldap']['server'] = 'ldap.localdomain'
default['openldap']['port'] = 389
default['openldap']['server_uri'] = "ldap://#{openldap['server']}/"
default['openldap']['tls_enabled'] = true

# The NSS filters here determine what users and groups the machine knows about
default['openldap']['nss_base']['passwd'] = ["ou=people,#{node['openldap']['basedn']}"]
default['openldap']['nss_base']['shadow'] = ["ou=people,#{node['openldap']['basedn']}"]
default['openldap']['nss_base']['group'] = ["ou=groups,#{node['openldap']['basedn']}"]
default['openldap']['nss_base']['automount'] = ["ou=automount,#{node['openldap']['basedn']}"]

unless node['domain'].nil? || node['domain'].split('.').count < 2
  default['openldap']['basedn'] = "dc=#{node['domain'].split('.').join(',dc=')}"
  default['openldap']['server'] = "ldap.#{node['domain']}"
end

default['openldap']['rootpw'] = nil
default['openldap']['preseed_dir'] = '/var/cache/local/preseeding'
default['openldap']['pam_password'] = 'md5'
default['openldap']['loglevel'] = 'sync config'
default['openldap']['schemas'] = %w(core.schema cosine.schema nis.schema inetorgperson.schema)

# dynamically generated pam.d files
# additional attributes added here will be added to the common-account, common-auth, common-password, and common-session files
default['openldap']['pam_hash']['account']['sufficient'] = %w(pam_unix.so)
default['openldap']['pam_hash']['account']['[default=bad success=ok user_unknown=ignore]'] = %w(pam_ldap.so)
default['openldap']['pam_hash']['auth']['sufficient'] = ['pam_unix.so likeauth nullok_secure', 'pam_ldap.so use_first_pass']
default['openldap']['pam_hash']['auth']['required'] = ['pam_group.so use_first_pass', 'pam_deny.so', 'pam_warn.so']
default['openldap']['pam_hash']['password']['sufficient'] = ['pam_unix.so nullok obscure min=8 max=8 md5', 'pam_ldap.so']
default['openldap']['pam_hash']['session']['required'] = ['pam_unix.so', 'pam_mkhomedir.so skel=/etc/skel/', 'pam_ldap.so']

default['openldap']['manage_ssl'] = false
default['openldap']['tls_checkpeer'] = false
default['openldap']['ssl_dir'] = "#{openldap['dir']}/ssl"
default['openldap']['cafile']  = nil
default['openldap']['ssl_cert'] = "#{openldap['ssl_dir']}/#{openldap['server']}_cert.pem"
default['openldap']['ssl_key'] = "#{openldap['ssl_dir']}/#{openldap['server']}.pem"
default['openldap']['ssl_cert_source_cookbook'] = 'openldap'
default['openldap']['ssl_cert_source_path'] = "ssl/#{node['openldap']['server']}_cert.pem"
default['openldap']['ssl_key_source_cookbook'] = 'openldap'
default['openldap']['ssl_key_source_path'] = "ssl/#{node['openldap']['server']}.pem"

default['openldap']['slapd_type'] = nil

# syncrepl slave syncing attributes
default['openldap']['slapd_master'] = node['openldap']['server']
default['openldap']['slapd_replpw'] = nil
default['openldap']['slapd_rid'] = 102
default['openldap']['syncrepl_interval'] = '01:00:00:00'
default['openldap']['syncrepl_type'] = 'refreshAndPersist'
default['openldap']['syncrepl_filter'] = '(objectClass=*)'
default['openldap']['syncrepl_use_tls'] = 'no' # yes or no
default['openldap']['syncrepl_dn'] = "cn=syncrole,#{node['openldap']['basedn']}"

# These the config hashes are dynamically parsed into the slapd.config and ldap.config files
# You can add to the hashes in wrapper cookbooks to add your own config options via wrapper cokbooks
# see readme for usage information

# The maximum number of entries that is returned for a search operation
default['openldap']['server_config_hash']['sizelimit'] = 500

default['openldap']['client_config_hash']['ldap_version'] = 3
default['openldap']['client_config_hash']['bind_policy'] = 'soft'
default['openldap']['client_config_hash']['pam_password'] = openldap['pam_password']

# package settings
default['openldap']['package_install_action'] = :install
