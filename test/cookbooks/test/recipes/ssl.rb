# frozen_string_literal: true

ssl_dir = '/etc/ldap/ssl'
server = 'ldap.example.com'

directory '/etc/ldap' do
  mode '0755'
end

directory ssl_dir do
  mode '0755'
end

%W(#{server}.crt #{server}.key #{server}.pem).each do |cert_file|
  cookbook_file "#{ssl_dir}/#{cert_file}" do
    source cert_file
    backup false
    action :create_if_missing
    mode '0644'
  end
end

openldap_install 'default'

openldap_service 'slapd' do
  server server
  rootpw 'password'
  tls_enabled true
  ldaps_enabled true
  tls_cert "#{ssl_dir}/#{server}.crt"
  tls_key "#{ssl_dir}/#{server}.key"
  tls_cafile "#{ssl_dir}/#{server}.pem"
end
