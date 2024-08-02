node.default['openldap']['accesslog']['enabled'] = true
node.default['openldap']['accesslog']['logdb'] = '"cn=accesslog"'
node.default['openldap']['accesslog']['directory'] = '/var/lib/ldap/accesslog'
node.default['openldap']['accesslog']['index'] = 'reqStart,reqEnd,reqResult eq'
node.default['openldap']['accesslog']['logops'] = 'writes'
node.default['openldap']['accesslog']['logold'] = '(objectclass=*)'
node.default['openldap']['accesslog']['logpurge'] = '8+00:00 1+00:00'

node.default['openldap']['modules'] << 'accesslog'

user 'openldap' do
  action :create
end

group 'openldap' do
  action :create
end

directories = ['/var/lib/ldap', '/var/lib/ldap/accesslog']

directories.each do |dir|
  directory dir do
    mode '0755'
    owner 'openldap'
    group 'openldap'
    action :create
  end
end

include_recipe 'openldap::default'
