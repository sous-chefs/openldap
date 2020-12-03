#
# Cookbook:: openldap
# Recipe:: default
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

openldap_install 'Install packages' do
  package_action node['openldap']['package_install_action']
end

template openldap_defaults_path do
  source openldap_defaults_template
  notifies :restart, 'service[slapd]'
end

##  Set syncrepl_consumer_config dynamic values here
node.default_unless['openldap']['syncrepl_consumer_config']['searchbase'] = "\"#{node['openldap']['basedn']}\""
node.default_unless['openldap']['syncrepl_consumer_config']['binddn'] = "\"#{node['openldap']['syncrepl_cn']},#{node['openldap']['basedn']}\""
node.default_unless['openldap']['syncrepl_consumer_config']['credentials'] = "\"#{node['openldap']['slapd_replpw']}\""

template "#{openldap_dir}/slapd.conf" do
  source 'slapd.conf.erb'
  helpers(::Openldap::Cookbook::Helpers)
  mode '0640'
  owner openldap_system_acct
  group openldap_system_group
  sensitive true
  notifies :restart, 'service[slapd]', :immediately
end

systemd_unit 'slapd.service' do
  content openldap_el8_systemd_unit
  action [:create]
end if platform_family?('rhel') && node['platform_version'].to_i >= 8

service 'slapd' do
  action [:enable, :start]
end
