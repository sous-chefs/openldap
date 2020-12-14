require 'spec_helper'

describe 'default recipe on ubuntu 20.04' do
  cached(:runner) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '20.04', step_into: ['openldap_install']) }
  cached(:chef_run) { runner.converge('openldap::default') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end

  it 'installs the openldap server packages' do
    expect(chef_run).to install_package('slapd')
  end

  it 'installs the openldap client packages' do
    expect(chef_run).to install_package('ldap-utils')
  end

  it 'installs the dbd package' do
    expect(chef_run).to install_package('db-util')
  end

  it do
    expect(chef_run).to create_template('/etc/default/slapd').with(source: 'default_slapd.erb')
  end

  it do
    expect(chef_run).to create_template('/etc/ldap/slapd.conf').with(owner: 'openldap', group: 'openldap')
  end

  it do
    expect(chef_run).to_not create_systemd_unit('slapd.service')
  end

  it do
    expect(chef_run).to enable_service('slapd')
    expect(chef_run).to start_service('slapd')
  end
end

describe 'default recipe on centos 7' do
  cached(:runner) { ChefSpec::ServerRunner.new(platform: 'centos', version: '7', step_into: ['openldap_install']) }
  cached(:chef_run) { runner.converge('openldap::default') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end

  it 'installs the openldap server package' do
    expect(chef_run).to install_package('openldap-servers')
  end

  it 'installs the openldap client packages' do
    expect(chef_run).to install_package('openldap-clients')
  end

  it 'installs the dbd package' do
    expect(chef_run).to install_package('compat-db47')
  end

  it do
    expect(chef_run).to_not create_yum_repository('osuosl-openldap')
  end

  it do
    expect(chef_run).to create_template('/etc/sysconfig/slapd').with(source: 'sysconfig_slapd.erb')
  end

  it do
    expect(chef_run).to create_template('/etc/openldap/slapd.conf').with(owner: 'ldap', group: 'ldap')
  end

  it do
    expect(chef_run).to_not create_systemd_unit('slapd.service')
  end

  it do
    expect(chef_run).to enable_service('slapd')
    expect(chef_run).to start_service('slapd')
  end
end

describe 'default recipe on centos 8' do
  cached(:runner) { ChefSpec::ServerRunner.new(platform: 'centos', version: '8', step_into: ['openldap_install']) }
  cached(:chef_run) { runner.converge('openldap::default') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end

  it 'installs the openldap server package' do
    expect(chef_run).to install_package('openldap-servers')
  end

  it 'installs the openldap client packages' do
    expect(chef_run).to install_package('openldap-clients')
  end

  it do
    expect(chef_run).to create_yum_repository('osuosl-openldap').with(
      baseurl: 'https://ftp.osuosl.org/pub/osl/repos/yum/$releasever/openldap/$basearch',
      gpgkey: 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl',
      description: 'OSUOSL OpenLDAP repository',
      gpgcheck: true,
      enabled: true
    )
  end

  it do
    expect(chef_run).to_not install_package('compat-db47')
  end

  it do
    expect(chef_run).to create_template('/etc/sysconfig/slapd').with(source: 'sysconfig_slapd.erb')
  end

  it do
    expect(chef_run).to create_template('/etc/openldap/slapd.conf').with(owner: 'ldap', group: 'ldap')
  end

  it do
    expect(chef_run).to create_systemd_unit('slapd.service')
  end

  it do
    expect(chef_run).to enable_service('slapd')
    expect(chef_run).to start_service('slapd')
  end
end

describe 'default recipe on freebsd 12' do
  cached(:runner) { ChefSpec::ServerRunner.new(platform: 'freebsd', version: '12', step_into: ['openldap_install']) }
  cached(:chef_run) { runner.converge('openldap::default') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end

  it 'installs the openldap server package' do
    expect(chef_run).to install_package('openldap-server')
  end

  it 'installs the openldap client packages' do
    expect(chef_run).to install_package('openldap-client')
  end

  it 'does not install the dbd package' do
    expect(chef_run).to install_package('libdbi')
  end

  it do
    expect(chef_run).to create_template('/etc/rc.conf.d/slapd').with(source: 'rc_slapd.erb')
  end

  it do
    expect(chef_run).to create_template('/usr/local/etc/openldap/slapd.conf').with(owner: 'ldap', group: 'ldap')
  end

  it do
    expect(chef_run).to_not create_systemd_unit('slapd.service')
  end

  it do
    expect(chef_run).to enable_service('slapd')
    expect(chef_run).to start_service('slapd')
  end
end
