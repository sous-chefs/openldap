# Cookbook:: openldap
# Attributes:: default
#
# Copyright:: 2008-2019, Chef Software, Inc.
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

# backing database
if platform_family?('freebsd')
  default['openldap']['modules'] = %w(back_mdb)
  default['openldap']['database'] = 'mdb'
else
  default['openldap']['modules'] = %w(back_hdb)
  default['openldap']['database'] = 'hdb'
  default['openldap']['dbconfig']['set_cachesize'] = '0 31457280 0'
  default['openldap']['dbconfig']['set_lk_max_objects'] = '1500'
  default['openldap']['dbconfig']['set_lk_max_locks'] = '1500'
  default['openldap']['dbconfig']['set_lk_max_lockers'] = '1500'
end

# package settings
default['openldap']['package_install_action'] = :install
default['openldap']['package_install_repository'] = true

#
# openldap configuration (generally overwritten by the user)
#

default['openldap']['basedn'] = 'dc=localdomain'
default['openldap']['cn'] = 'admin'
default['openldap']['admin_cn'] = 'administrators'
default['openldap']['server'] = 'ldap.localdomain'

unless node['domain'].nil? || node['domain'].split('.').count < 2
  default['openldap']['basedn'] = "dc=#{node['domain'].split('.').join(',dc=')}"
  default['openldap']['server'] = "ldap.#{node['domain']}"
end

default['openldap']['rootpw'] = nil
default['openldap']['preseed_dir'] = '/var/cache/local/preseeding'
default['openldap']['loglevel'] = 'sync config'
default['openldap']['schemas'] = %w(core.schema cosine.schema nis.schema inetorgperson.schema)
default['openldap']['indexes'] = [
  'default pres,eq,approx,sub',
  'objectClass eq',
  'cn,ou,sn,uid,l,mail,gecos,memberUid,description',
  'loginShell,homeDirectory pres,eq,approx',
  'uidNumber,gidNumber pres,eq',
]
default['openldap']['user_attrs'] = 'userPassword,shadowLastChange'

# TLS/SSL
default['openldap']['ldaps_enabled'] = false
default['openldap']['tls_enabled'] = false
default['openldap']['tls_cert'] = nil
default['openldap']['tls_key'] = nil
default['openldap']['tls_cafile'] = nil
default['openldap']['tls_ciphersuite'] = nil

# syncrepl
default['openldap']['slapd_type'] = nil
default['openldap']['slapd_provider'] = nil
default['openldap']['slapd_replpw'] = nil
default['openldap']['slapd_rid'] = 102
default['openldap']['syncrepl_uri'] = 'ldap'
default['openldap']['syncrepl_port'] = '389'

# syncrepl_cn affects provider and consumer
default['openldap']['syncrepl_cn'] = 'cn=syncrole'

# syncrepl provider config parameters
default['openldap']['syncrepl_provider_config']['overlay'] = 'syncprov'
default['openldap']['syncrepl_provider_config']['syncprov-checkpoint'] = '100 10'
default['openldap']['syncrepl_provider_config']['syncprov-sessionlog'] = '100'

# syncrepl consumer config parameters
default['openldap']['syncrepl_consumer_config']['type'] = 'refreshAndPersist'
default['openldap']['syncrepl_consumer_config']['interval'] = '01:00:00:00'
default['openldap']['syncrepl_consumer_config']['searchbase'] = nil
default['openldap']['syncrepl_consumer_config']['filter'] = '"(objectClass=*)"'
default['openldap']['syncrepl_consumer_config']['scope'] = 'sub'
default['openldap']['syncrepl_consumer_config']['schemachecking'] = 'off'
default['openldap']['syncrepl_consumer_config']['bindmethod'] = 'simple'
default['openldap']['syncrepl_consumer_config']['binddn'] = nil
default['openldap']['syncrepl_consumer_config']['starttls'] = 'no' # yes or no
default['openldap']['syncrepl_consumer_config']['credentials'] = nil

# The server_config_hash hash is parsed directly into the slapd.conf file
# You can add to the hashes in wrapper cookbooks to add your own config options

# The maximum number of entries that is returned for a search operation
default['openldap']['server_config_hash']['sizelimit'] = 500

# The iam default block is to setup custom admin acls. 
default['openldap']['iam'] = [
  {
    'what': '*',
    'type': [
      {
        'who': 'self',
        'access': 'write',
      },
      {
        'who': '*',
        'access': 'read',
      },
    ],
  },
]