# Migration

## Breaking API Change

The cookbook now exposes custom resources only. The `openldap::default` recipe and
`node['openldap']` attributes have been removed.

## Before

```ruby
include_recipe 'openldap::default'

node.default['openldap']['rootpw'] = '{SSHA}example'
node.default['openldap']['tls_enabled'] = true
```

## After

```ruby
openldap_install 'default'

openldap_service 'slapd' do
  rootpw '{SSHA}example'
  tls_enabled true
  tls_cert '/etc/ldap/ssl/ldap.example.com.crt'
  tls_key '/etc/ldap/ssl/ldap.example.com.key'
end
```

## Test Cookbook Examples

Runnable usage examples live in `test/cookbooks/test/recipes/`:

* `default.rb` installs and starts OpenLDAP.
* `ssl.rb` enables TLS and LDAPS.
* `provider.rb` configures provider replication settings.
* `consumer.rb` configures consumer replication settings.
