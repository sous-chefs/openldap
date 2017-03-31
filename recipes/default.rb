#
# Cookbook:: openldap
# Recipe:: default
#
# Copyright:: 2008-2016, Chef Software, Inc.
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

case node['platform_family']
when 'debian'
  template '/etc/default/slapd' do
    source 'default_slapd.erb'
  end
when 'rhel'
  if node['platform_version'].to_i >= 7 && !platform?('amazon')
    template '/etc/sysconfig/slapd' do
      source 'sysconfig_slapd.erb'
    end
  else
    template '/etc/sysconfig/ldap' do
      source 'sysconfig_slapd.erb'
    end
  end
when 'suse'
  template '/etc/sysconfig/openldap' do
    source 'sysconfig_openldap.erb'
  end
when 'freebsd'
  template '/etc/rc.conf.d/slapd' do
    source 'rc_slapd.erb'
  end
end

template "#{node['openldap']['dir']}/slapd.conf" do
  source 'slapd.conf.erb'
  mode '0640'
  owner node['openldap']['system_acct']
  group node['openldap']['system_group']
  notifies :restart, 'service[slapd]', :immediately
end

service 'slapd' do
  action [:enable, :start]
end
