require 'spec_helper'

describe 'server recipe on ubuntu 16.04' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') }
  let(:chef_run) { runner.converge('openldap::server') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end

describe 'server recipe on centos 6' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511') }
  let(:chef_run) { runner.converge('openldap::server') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end

describe 'server recipe on centos 7' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'centos', version: '6.8') }
  let(:chef_run) { runner.converge('openldap::server') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end

describe 'server recipe on freebsd 10' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'freebsd', version: '10.3') }
  let(:chef_run) { runner.converge('openldap::server') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end
