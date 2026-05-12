# frozen_string_literal: true

openldap_install 'default'

openldap_service 'slapd' do
  rootpw 'password'
  slapd_type 'provider'
end
