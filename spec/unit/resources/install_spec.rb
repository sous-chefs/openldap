# frozen_string_literal: true

require 'spec_helper'

describe 'openldap_install' do
  step_into :openldap_install

  context 'on ubuntu 24.04' do
    platform 'ubuntu', '24.04'

    recipe do
      openldap_install 'default'
    end

    it { is_expected.to install_package('slapd') }
    it { is_expected.to install_package('ldap-utils') }
    it { is_expected.to install_package('db-util') }
    it { is_expected.to create_directory('/var/cache/local/preseeding') }
    it { is_expected.to create_file('/var/cache/local/preseeding/slapd.seed') }
    it { is_expected.to_not run_execute('preseed slapd') }
  end

  context 'on almalinux 8' do
    platform 'almalinux', '8'

    recipe do
      openldap_install 'default'
    end

    it { is_expected.to install_package('openldap-servers') }
    it { is_expected.to install_package('openldap-clients') }
    it { is_expected.to create_yum_repository('osuosl-openldap') }
  end

  context 'remove on ubuntu 24.04' do
    platform 'ubuntu', '24.04'

    recipe do
      openldap_install 'default' do
        action :remove
      end
    end

    it { is_expected.to remove_package('slapd') }
    it { is_expected.to remove_package('ldap-utils') }
    it { is_expected.to remove_package('db-util') }
    it { is_expected.to delete_file('/var/cache/local/preseeding/slapd.seed') }
    it { is_expected.to delete_directory('/var/cache/local/preseeding') }
  end
end
