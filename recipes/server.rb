#
# Cookbook Name:: openldap
# Recipe:: server
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
include_recipe 'openldap::client'

case node['platform_family']
when 'debian'
  package "#{node['openldap']['packages']['bdb']}" do
    action node['openldap']['package_install_action']
  end

  directory node['openldap']['preseed_dir'] do
    action :create
    recursive true
    mode '0700'
    owner 'root'
    group 'root'
  end

  cookbook_file "#{node['openldap']['preseed_dir']}/slapd.seed" do
    source 'slapd.seed'
    mode '0600'
    owner 'root'
    group 'root'
  end

  package 'slapd' do
    response_file 'slapd.seed'
    action node['openldap']['package_install_action']
  end
else
  package "#{node['openldap']['packages']['bdb']}" do
    action node['openldap']['package_install_action']
  end

  package 'slapd' do
    action node['openldap']['package_install_action']
  end
end

if node['openldap']['tls_enabled'] && node['openldap']['manage_ssl']
  cookbook_file node['openldap']['ssl_cert'] do
    source node['openldap']['ssl_cert_source_path']
    cookbook node['openldap']['ssl_cert_source_cookbook']
    mode '0644'
    owner 'root'
    group 'root'
  end

  cookbook_file node['openldap']['ssl_key'] do
    source node['openldap']['ssl_key_source_path']
    cookbook node['openldap']['ssl_key_source_cookbook']
    mode '0644'
    owner 'root'
    group 'root'
  end
end

if node['platform_family'] == 'debian'
  template '/etc/default/slapd' do
    source 'default_slapd.erb'
    owner 'root'
    group 'root'
    mode '0644'
  end

  directory "#{node['openldap']['dir']}/slapd.d" do
    recursive true
    owner 'openldap'
    group 'openldap'
    action :create
  end

  execute 'slapd-config-convert' do
    command "slaptest -f #{node['openldap']['dir']}/slapd.conf -F #{node['openldap']['dir']}/slapd.d/"
    user 'openldap'
    action :nothing
    notifies :start, 'service[slapd]', :immediately
  end

  template "#{node['openldap']['dir']}/slapd.conf" do
    source 'slapd.conf.erb'
    mode '0640'
    owner 'openldap'
    group 'openldap'
    notifies :stop, 'service[slapd]', :immediately
    notifies :run, 'execute[slapd-config-convert]'
  end
else
  template "#{node['openldap']['dir']}/slapd.conf" do
    source 'slapd.conf.erb'
    mode '0640'
    owner 'openldap'
    group 'openldap'
    notifies :restart, 'service[slapd]'
  end
end

service 'slapd' do
  action [:enable, :start]
end
