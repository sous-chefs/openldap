#
# Cookbook Name:: openldap
# Recipe:: auth
#
# Copyright 2008-2009, Chef Software, Inc.
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

include_recipe "openldap::client"
include_recipe "openssh"

node['openldap']['packages']['auth'].each do |pkg|
  package pkg do
    action :upgrade
  end
end

template "/etc/ldap.conf" do
  source "ldap.conf.erb"
  mode 00644
  owner "root"
  group "root"
end

template "#{node['openldap']['dir']}/ldap.conf" do
  source "ldap-ldap.conf.erb"
  mode 00644
  owner "root"
  group "root"
end

cookbook_file '/etc/pam.d/ldap' do
  source 'pam.d-ldap'
  mode 00644
  owner "root"
  group "root"
  notifies :restart, "service[ssh]", :delayed
end

template "/etc/security/login_access.conf" do
  source "login_access.conf.erb"
  mode 00644
  owner "root"
  group "root"
end

template '/etc/nslcd.conf' do
  source 'nslcd.conf.erb'
  mode 0644
end

service 'nslcd' do
  action [:enable, :restart]
end

cookbook_file "/etc/nsswitch.conf" do
  source "nsswitch.conf"
  mode 00644
  owner "root"
  group "root"
end
