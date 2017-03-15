ssl_dir = "#{node['openldap']['dir']}/ssl"
node.default['openldap']['tls_cert'] = "#{ssl_dir}/#{node['openldap']['server']}.crt"
node.default['openldap']['tls_key'] = "#{ssl_dir}/#{node['openldap']['server']}.key"
node.default['openldap']['tls_cafile'] = "#{ssl_dir}/#{node['openldap']['server']}.pem"

node.default[:certs] = ["#{ssl_dir}/#{node['openldap']['server']}.crt",
                        "#{ssl_dir}/#{node['openldap']['server']}.key",
                        "#{ssl_dir}/#{node['openldap']['server']}.pem"]

hostsfile_entry '127.0.1.1' do
  hostname node['openldap']['server']
  action :append
end

directory node['openldap']['dir'] do
  mode '755'
  action :create
end

directory ssl_dir do
  mode '755'
  action :create
end

node['certs'].each do |c|
  cookbook_file c do
    backup false
    action :create_if_missing
    owner 'root'
    group 'root'
    mode '644'
  end
end

include_recipe 'openldap::default'
