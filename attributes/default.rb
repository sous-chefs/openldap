# Cookbook Name:: openldap
# Attributes:: openldap
#
# Copyright 2008-2009, Opscode, Inc.
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

default['openldap']['basedn'] = "dc=localdomain"
default['openldap']['server'] = "ldap.localdomain"

if node['domain'].length > 0
  default['openldap']['basedn'] = "dc=#{node['domain'].split('.').join(",dc=")}"
  default['openldap']['server'] = "ldap.#{node['domain']}"
end

default['openldap']['rootpw'] = nil

# File and directory locations for openldap.
case node['platform']
when "redhat","centos","amazon","scientific"
  default['openldap']['dir']        = "/etc/openldap"
  default['openldap']['run_dir']    = "/var/run/openldap"
  default['openldap']['module_dir'] = "/usr/lib64/openldap"
when "debian","ubuntu"
  default['openldap']['dir']        = "/etc/ldap"
  default['openldap']['run_dir']    = "/var/run/slapd"
  default['openldap']['module_dir'] = "/usr/lib/ldap"
else
  default['openldap']['dir']        = "/etc/ldap"
  default['openldap']['run_dir']    = "/var/run/slapd"
  default['openldap']['module_dir'] = "/usr/lib/ldap"
end

default['openldap']['ssl_dir'] = "#{openldap['dir']}/ssl"
default['openldap']['cafile']  = "#{openldap['ssl_dir']}/ca.crt"
default['openldap']['slapd_type'] = nil

default['openldap']['slapd_schema'] = [
  'core',
  'cosine',
  'nis',
  'inetorgperson'
]

default['openldap']['slapd_modules'] = [
  'back_hdb'
]

if node['openldap']['slapd_type'] == "slave"
  default['openldap']['slapd_master'] = node['openldap']['server']
  default['openldap']['slapd_replpw'] = nil
  default['openldap']['slapd_rid']    = 102
end

default['openldap']['slapd_loglevel'] = 0
default['openldap']['slapd_sizelimit'] = 500
default['openldap']['slapd_tool-threads'] = 1


default['openldap']['slapd_options'] = {}


# database config

default['openldap']['slapd_databases']['default']['type'] = 'hdb'
# set database options to nil, means use global ones, backward compatibility
default['openldap']['slapd_databases']['default']['suffix'] = nil
default['openldap']['slapd_databases']['default']['rootdn'] = nil
default['openldap']['slapd_databases']['default']['rootpw'] = nil
# default values
default['openldap']['slapd_databases']['default']['directory'] = "/var/lib/ldap"
default['openldap']['slapd_databases']['default']['lastmod'] = "on"


default['openldap']['slapd_databases']['default']['options']['dbconfig'] = [
  'set_cachesize 0 31457280 0',
  # Number of objects that can be locked at the same time.
  'set_lk_max_objects 1500',
  # Number of locks (both requested and granted)
  'set_lk_max_locks 1500',
  # Number of lockers
  'set_lk_max_lockers 1500'
]

default['openldap']['slapd_acls'] = {
  "00" => {
    "attrs" => "userPassword,shadowLastChange",
    "access" => {
      "00" => { "group.exact" =>"cn=administrators,#{node['openldap']['basedn']}", "action" => "write" },
      "10" => { "dn" => "cn=syncrole,#{node['openldap']['basedn']}", "action" => "read" },
      "20" => { "anonymous" => true, "action" => "auth" },
      "30" => { "self" => true, "action" => "write" },
      "40" => "none"
    }
  },
  "10" => {
    "dn" => "",
    "dntype" => "base",
    "access" => "read",
  },
  "20" => {
    "access" => {
      "00" => { "group.exact" => "cn=administrators,#{node['openldap']['basedn']}", "action" => "write" },
      "10" => { "dn" => "cn=syncrole,#{node['openldap']['basedn']}", "action" => "read" },
      "20" => "read"
    }
  }
}


default['openldap']['slapd_databases']['default']['indexes']['default'] = 'pres,eq,approx,sub'
default['openldap']['slapd_databases']['default']['indexes']['objectClass'] = 'eq'
default['openldap']['slapd_databases']['default']['indexes']['cn,ou,sn,uid,l,mail,gecos,memberUid,description'] = '' # means default
default['openldap']['slapd_databases']['default']['indexes']['loginShell,homeDirectory'] = 'pres,eq,approx'
default['openldap']['slapd_databases']['default']['indexes']['uidNumber,gidNumber'] = 'pres,eq'

# Auth settings for Apache
if node['openldap']['basedn'] && node['openldap']['server']
  default['openldap']['auth_type']   = "openldap"
  default['openldap']['auth_binddn'] = "ou=people,#{openldap['basedn']}"
  default['openldap']['auth_bindpw'] = nil
  default['openldap']['auth_url']    = "ldap://#{openldap['server']}/#{openldap['auth_binddn']}?uid?sub?(objecctClass=*)"
end
