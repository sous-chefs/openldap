#
# Cookbook Name:: openldap
# Recipe:: anon_user
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


# Set up a anon user for auth purpose
node.set_unless['openldap']['anon_binddn'] = "cn=anon,#{node['openldap']['basedn']}"
unless node['openldap']['anon_pass']
  node.set['openldap']['anon_pass']= secure_password
  anon_pass = Chef::ShellOut.new("slappasswd -h {ssha} -s #{node['openldap']['anon_pass']}").run_command
  node.set['openldap']['anon_hash']= anon_pass.stdout.chomp
end


openldap_node node['openldap']['anon_binddn'] do
  attributes ({
    :objectClass => ["account","simpleSecurityObject","top"],
    :uid => node['openldap']['anon_user'],
    :userPassword => node['openldap']['anon_hash']
  })
end

# Set up a admin user to maintain database
node.set_unless['openldap']['admin_binddn'] = "cn=admin,#{node['openldap']['basedn']}"
unless node['openldap']['admin_password']
  node.set['openldap']['admin_password']= secure_password
  admin_pass = Chef::ShellOut.new("slappasswd -h {ssha} -s #{node['openldap']['admin_password']}").run_command
#    Chef::Log.info(admin_pass)
  node.set['openldap']['admin_hash']= admin_pass.stdout.chomp
end

openldap_node node['openldap']['admin_binddn'] do
  attributes ({
    :objectClass => ["account","simpleSecurityObject","top"],
    :uid => node['openldap']['anon_user'],
    :userPassword => node['openldap']['anon_hash']
  })
end
  
openldap_config "olcDatabase={1}hdb,cn=config" do
  attributes ({
    :olcDbDirectory => node['openldap']['db_dir'],
    :olcSuffix => node['openldap']['basedn'],
    :olcAccess => [ 
      "{0}to attrs=userPassword,shadowLastChange 
          by self write 
          by anonymous auth 
          by dn=\"#{node['openldap']['admin_binddn']}\" write 
          by dn=\"#{node['openldap']['anon_binddn']}\" read 
          by * none",
      "{1}to dn.base="" 
          by * read",
      "{2}to * 
          by self write 
          by dn=\"#{node['openldap']['admin_binddn']}\" write 
          by dn=\"#{node['openldap']['anon_binddn']}\" read"
    ],
    :olcLastMod => "TRUE",
    :olcRootDN => node['openldap']['admin_binddn'],
    :olcRootPW => node['openldap']['admin_hash']
  })
end
