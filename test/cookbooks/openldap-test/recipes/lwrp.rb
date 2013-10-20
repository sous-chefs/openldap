include_recipe "openldap::master"
include_recipe "openldap::auth"

openldap_config "cn=test,cn=schema,cn=config" do
  template "schema=test.ldif.erb" 
  action :create
end

openldap_node "ou=Groups,#{node['openldap']['basedn']}" do
  attributes ({ 
    :objectClass => ["organizationalUnit","top"],
    :ou => "Groups"})
end
