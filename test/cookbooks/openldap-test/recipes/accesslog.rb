ldap_dir =
  case os.family
  when 'debian'
    '/etc/ldap'
  when 'redhat', 'amazon', 'fedora', 'suse'
    '/etc/openldap'
  when 'bsd'
    '/usr/local/etc/openldap'
  end

node.default['openldap']['accesslog']['enabled'] = true
node.default['openldap']['accesslog']['logdb'] = '"cn=accesslog"'
node.default['openldap']['accesslog']['directory'] = '#{ldap_dir}/accesslog'
node.default['openldap']['accesslog']['index'] = 'reqStart,reqEnd,reqResult eq'
node.default['openldap']['accesslog']['logops'] = 'writes'
node.default['openldap']['accesslog']['logold'] = '(objectclass=*)'
node.default['openldap']['accesslog']['logpurge'] = '8+00:00 1+00:00'

node.default['openldap']['modules'] << 'accesslog'

directory '#{ldap_dir}/accesslog' do
  mode '0755'
  owner 'openldap'
  group 'openldap'
  action :create
end

include_recipe 'openldap::default'
