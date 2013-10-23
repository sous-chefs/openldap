#
# Cookbook Name:: openldap
# Recipe:: users
#
# Copyright 2013, Christian Fischer, computerlyrik
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


::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

################################################
# Set up a anon user for auth and search purpose
################################################
node.set_unless['openldap']['anon_user'] = "anon"
node.set_unless['openldap']['anon_binddn'] = "cn=#{node['openldap']['anon_user']},#{node['openldap']['basedn']}"
unless node['openldap']['anon_pass']
  node.set['openldap']['anon_pass'] = secure_password
  anon_pass = Mixlib::ShellOut.new("slappasswd -h {ssha} -s #{node['openldap']['anon_pass']}").run_command
  Chef::Log.info(anon_pass.stdout)
  node.set['openldap']['anon_hash'] = anon_pass.stdout.chomp
end


openldap_node node['openldap']['anon_binddn'] do
  attributes ({
    :objectClass => ["organizationalRole","shadowAccount" ],
    :uid => node['openldap']['anon_user'],
    :userPassword => node['openldap']['anon_hash']
  })
end
  
=begin UNUSED
openldap_config "olcDatabase={1}hdb,cn=config" do
  attributes ({
    :olcDbDirectory => node['openldap']['db_dir'],
    :olcSuffix => node['openldap']['basedn'],
    :olcAccess => [ 
      "{0}to attrs=userPassword,shadowLastChange 
          by self write 
          by anonymous auth 
          by dn=\"#{node['openldap']['rootdn']}\" write 
          by dn=\"#{node['openldap']['anon_binddn']}\" read 
          by * none",
      "{1}to dn.base="" 
          by * read",
      "{2}to * 
          by self write 
          by dn=\"#{node['openldap']['rootdn']}\" write 
          by dn=\"#{node['openldap']['anon_binddn']}\" read"
    ],
    :olcLastMod => "TRUE",
    :olcRootDN => node['openldap']['rootdn'],
    :olcRootPW => node['openldap']['roothash']
  })
end
=end

################################################
# Set up a structure for users and groups
################################################

openldap_node "ou=Users,#{node['openldap']['basedn']}" do
  attributes ({
    :objectClass => ["organizationalUnit", "top"],
    :ou => "Users"
  })
end

openldap_node "ou=Groups,#{node['openldap']['basedn']}" do
  attributes ({ 
    :objectClass => ["organizationalUnit","top"],
    :ou => "Groups"})
end

openldap_node "cn=User,ou=Groups,#{node['openldap']['basedn']}" do
  attributes ({
    :gidNumber => "500",
    :cn => "User",
    :objectClass => ["posixGroup", "top"]
  })
end

node.set['openldap']['users_root'] = "ou=Users,#{node['openldap']['basedn']}"
