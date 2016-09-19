require 'spec_helper'

describe 'server recipe on ubuntu 16.04' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['openldap_install']) }
  let(:chef_run) { runner.converge('openldap::server') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end

  it 'installs the openldap server packages' do
    expect(chef_run).to install_package(%w( slapd ldap-utils ))
  end

  it 'installs the dbd package' do
    expect(chef_run).to install_package('db-util')
  end
end

describe 'server recipe on centos 6' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511', step_into: ['openldap_install']) }
  let(:chef_run) { runner.converge('openldap::server') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end

  it 'installs the openldap server package' do
    expect(chef_run).to install_package('openldap-servers')
  end

  it 'installs the dbd package' do
    expect(chef_run).to install_package('compat-db47')
  end
end

describe 'server recipe on centos 7' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'centos', version: '6.8', step_into: ['openldap_install']) }
  let(:chef_run) { runner.converge('openldap::server') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end

  it 'installs the openldap server package' do
    expect(chef_run).to install_package('openldap-servers')
  end

  it 'installs the dbd package' do
    expect(chef_run).to install_package('db4-utils')
  end
end

describe 'server recipe on freebsd 10' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'freebsd', version: '10.3', step_into: ['openldap_install']) }
  let(:chef_run) { runner.converge('openldap::server') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end

  it 'installs the openldap server package' do
    expect(chef_run).to install_package('openldap-server')
  end

  it 'does not install the dbd package' do
    expect(chef_run).to_not install_package('libdbi')
  end
end
