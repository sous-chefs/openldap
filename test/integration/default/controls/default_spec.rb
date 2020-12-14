server_pkg =
  if os.debian?
    'slapd'
  elsif os.redhat?
    'openldap-servers'
  elsif os.suse?
    'openldap2'
  elsif os.linux?
    'openldap-servers'
  elsif os.bsd?
    'openldap-server'
  end

client_pkg =
  if os.debian?
    'ldap-utils'
  elsif os.redhat?
    'openldap-clients'
  elsif os.suse?
    'openldap2-client'
  elsif os.linux?
    'openldap-clients'
  elsif os.bsd?
    'openldap-client'
  end

control 'default' do
  describe package client_pkg do
    it { should be_installed }
  end

  describe package server_pkg do
    it { should be_installed }
  end

  describe service 'slapd' do
    it { should be_installed }
    it { should be_running }
  end

  describe port '389' do
    it { should be_listening }
  end
end
