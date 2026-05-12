# frozen_string_literal: true

openldap_install 'default'

openldap_service 'slapd' do
  basedn 'dc=example,dc=com'
  rootpw 'password'
  server 'ldap.example.com'
  slapd_type 'consumer'
end
