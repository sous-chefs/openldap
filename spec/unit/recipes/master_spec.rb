require 'spec_helper'

describe 'master recipe on ubuntu 16.04' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') }
  let(:chef_run) { runner.converge('openldap::master') }
  let(:node) { chef_run.node }
  
  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end

  it 'sets the correct ssl_dir attribute' do
    expect(node['openldap']['ssl_dir']).to eq('/etc/ldap/ssl')
  end

  it 'sets the correct ssl_cert attribute' do
    expect(node['openldap']['ssl_cert']).to eq('/etc/ldap/ssl/ldap.localdomain_cert.pem')
  end

  it 'sets the correct ssl_cert attribute' do
    expect(node['openldap']['ssl_key']).to eq('/etc/ldap/ssl/ldap.localdomain.pem')
  end
end
