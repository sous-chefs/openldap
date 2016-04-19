#
# Cookbook Name:: openldap
# Recipe:: auth
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

include_recipe 'openldap::client'

node['openldap']['packages']['auth_pkgs'].each do |pkg|
  package pkg do
    action node['openldap']['package_install_action']
  end
end

template '/etc/ldap.conf' do
  source 'ldap.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
end

template "#{node['openldap']['dir']}/ldap.conf" do
  source 'ldap-ldap.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
end

cookbook_file '/etc/nsswitch.conf' do
  source 'nsswitch.conf'
  mode '0644'
  owner 'root'
  group 'root'
  if node['recipes'].include?('nscd::default')
    notifies :run, 'execute[nscd-clear-passwd]', :immediately
    notifies :run, 'execute[nscd-clear-group]', :immediately
    notifies :restart, 'service[nscd]', :immediately
  end
end

node['openldap']['pam_hash'].each_pair do |file, directives|
  template "/etc/pam.d/common-#{file}" do
    source 'common-pamd.erb'
    mode '0644'
    owner 'root'
    group 'root'
    variables(
      directives: directives,
      file: file
    )
    notifies :restart, 'service[ssh]', :delayed if node['recipes'].include?('openssh::default')
  end
end

template '/etc/security/login_access.conf' do
  source 'login_access.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
end
