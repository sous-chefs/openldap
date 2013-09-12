hostsfile_entry "127.0.1.1" do
  hostname "ldap.example.com"
  action :append
end

directory node[:openldap][:ssl_dir] do
  owner "root"
  group "root"
  mode 00755
  action :create
end

node[:certs].each do |c|
  cookbook_file c do
    backup false
    action :create_if_missing
    owner "root"
    group "root"
    mode 0644
  end
end
