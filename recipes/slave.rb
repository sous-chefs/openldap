#
# Cookbook Name:: openldap
# Recipe:: slave
#
# Copyright 2012-2015, Chef Software, Inc.
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

node.default['openldap']['slapd_type'] = 'slave'

if Chef::Config[:solo]
  Chef::Log.warn("To use #{cookbook_name}::#{recipe_name} with solo, set attributes node['openldap']['slapd_replpw'] and node['openldap']['slapd_master'].")
else
  ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
  node.default['openldap']['slapd_replpw'] = secure_password
  node.default['openldap']['slapd_master'] = search(:node, 'openldap_slapd_type:master').map { |n| n['openldap']['server'] }.first
  node.save
end

include_recipe 'openldap::server'
