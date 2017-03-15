# # encoding: utf-8

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

describe package(pkg) do
  it { should be_installed }
end

describe service('slapd') do
  it { should be_installed }
  it { should be_running }
end
