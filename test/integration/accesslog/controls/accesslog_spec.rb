ldap_dir =
  case os.family
  when 'debian'
    '/etc/ldap'
  when 'redhat', 'amazon', 'fedora', 'suse'
    '/etc/openldap'
  when 'bsd'
    '/usr/local/etc/openldap'
  end

control 'accesslog' do
  describe file "#{ldap_dir}/slapd.conf" do
    its('content') { should match /# accesslog configuration/ }
    its('content') { should match /overlay accesslog/ }
  end

  describe service('slapd') do
    it { should be_installed }
    it { should be_running }
  end
end
