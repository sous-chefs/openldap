# Cookbook Name:: openldap
# Attributes:: openldap
#
# Copyright 2008-2015, Chef Software, Inc.
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

default['openldap']['basedn'] = 'dc=localdomain'
default['openldap']['cn'] = 'admin'
default['openldap']['server'] = 'ldap.localdomain'
default['openldap']['server_uri'] = "ldap://#{openldap['server']}/"
default['openldap']['tls_enabled'] = true

default['openldap']['passwd_ou'] = 'people'
default['openldap']['shadow_ou'] = 'people'
default['openldap']['group_ou'] = 'groups'
default['openldap']['automount_ou'] = 'automount'

unless node['domain'].nil? || node['domain'].split('.').count < 2
  default['openldap']['basedn'] = "dc=#{node['domain'].split('.').join(',dc=')}"
  default['openldap']['server'] = "ldap.#{node['domain']}"
end

default['openldap']['loglevel'] = 0
default['openldap']['schemas'] = %w(core.schema cosine.schema nis.schema inetorgperson.schema)
default['openldap']['modules'] = %w(back_hdb)

default['openldap']['rootpw'] = nil

# File and directory locations for openldap.
case node['platform_family']
when 'rhel'
  default['openldap']['dir']        = '/etc/openldap'
  default['openldap']['run_dir']    = '/var/run/openldap'
  default['openldap']['module_dir'] = '/usr/lib64/openldap'
  default['openldap']['system_acct'] = 'ldap'
  default['openldap']['system_group'] = 'ldap'
when 'debian'
  default['openldap']['dir']        = '/etc/ldap'
  default['openldap']['run_dir']    = '/var/run/slapd'
  default['openldap']['module_dir'] = '/usr/lib/ldap'
  default['openldap']['system_acct'] = 'openldap'
  default['openldap']['system_group'] = 'openldap'
else
  default['openldap']['dir']        = '/etc/ldap'
  default['openldap']['run_dir']    = '/var/run/slapd'
  default['openldap']['module_dir'] = '/usr/lib/ldap'
  default['openldap']['system_acct'] = 'openldap'
  default['openldap']['system_group'] = 'openldap'
end

default['openldap']['preseed_dir'] = '/var/cache/local/preseeding'
default['openldap']['tls_checkpeer'] = false
default['openldap']['pam_password'] = 'md5'

default['openldap']['manage_ssl'] = true
default['openldap']['ssl_dir'] = "#{openldap['dir']}/ssl"
default['openldap']['cafile']  = nil
default['openldap']['ssl_cert'] = "#{openldap['ssl_dir']}/#{openldap['server']}_cert.pem"
default['openldap']['ssl_key'] = "#{openldap['ssl_dir']}/#{openldap['server']}.pem"
default['openldap']['ssl_cert_source_cookbook'] = 'openldap'
default['openldap']['ssl_cert_source_path'] = "ssl/#{node['openldap']['server']}_cert.pem"
default['openldap']['ssl_key_source_cookbook'] = 'openldap'
default['openldap']['ssl_key_source_path'] = "ssl/#{node['openldap']['server']}.pem"

default['openldap']['slapd_type'] = nil

if node['openldap']['slapd_type'] == 'slave'
  default['openldap']['slapd_master'] = node['openldap']['server']
  default['openldap']['slapd_replpw'] = nil
  default['openldap']['slapd_rid']    = 102
end

# package settings
default['openldap']['package_install_action'] = :install

case node['platform_family']
when 'debian'
  # precise and up and wheezy and up stopped putting the version name in the db-util package.
  # this is required to keep support for lucid
  if node['platform'] == 'ubuntu' && node['platform_version'].to_i < 12
    default['openldap']['packages']['bdb'] = 'db4.8-util'
  else
    default['openldap']['packages']['bdb'] = 'db-util'
  end
  default['openldap']['packages']['client_pkg'] = 'ldap-utils'
  default['openldap']['packages']['srv_pkg'] = 'slapd'
  default['openldap']['packages']['auth_pkgs'] = %w(libnss-ldap libpam-ldap)
when 'rhel'
  default['openldap']['packages']['bdb'] = 'db-utils'
  default['openldap']['packages']['client_pkg'] = 'openldap-clients'
  default['openldap']['packages']['srv_pkg'] = 'openldap-servers'
  default['openldap']['packages']['auth_pkgs'] = %w(nss-pam-ldapd)
else
  default['openldap']['packages']['bdb'] = 'db-utils'
  default['openldap']['packages']['client_pkg'] = 'ldap-utils'
  default['openldap']['packages']['srv_pkg'] = 'slapd'
  default['openldap']['packages']['auth_pkgs'] = %w(libnss-ldap libpam-ldap)
end
