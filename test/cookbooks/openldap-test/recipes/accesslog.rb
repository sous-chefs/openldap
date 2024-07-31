node.default['openldap']['accesslog']['enabled'] = true
node.default['openldap']['accesslog']['logdb'] = '"cn=accesslog"'
node.default['openldap']['accesslog']['directory'] = '/var/log/'
node.default['openldap']['accesslog']['index'] = 'reqStart,reqEnd,reqResult eq'
node.default['openldap']['accesslog']['logops'] = 'writes'
node.default['openldap']['accesslog']['logold'] = '(objectclass=*)'
node.default['openldap']['accesslog']['logpurge'] = '8+00:00 1+00:00' 

include_recipe 'openldap::default'