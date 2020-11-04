pkg = if os.debian?
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

control 'default' do
  describe package pkg do
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
