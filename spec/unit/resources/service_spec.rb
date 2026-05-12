# frozen_string_literal: true

require 'spec_helper'

describe 'openldap_service' do
  step_into :openldap_service

  context 'on ubuntu 24.04' do
    platform 'ubuntu', '24.04'

    recipe do
      openldap_service 'slapd' do
        rootpw 'password'
      end
    end

    it { is_expected.to create_template('/etc/default/slapd').with(source: 'default_slapd.erb') }
    it { is_expected.to create_template('/etc/ldap/slapd.conf').with(owner: 'openldap', group: 'openldap') }
    it { is_expected.to enable_service('slapd') }
    it { is_expected.to start_service('slapd') }
    it { is_expected.not_to create_systemd_unit('slapd.service') }
  end

  context 'on almalinux 8' do
    platform 'almalinux', '8'

    recipe do
      openldap_service 'slapd' do
        rootpw 'password'
      end
    end

    it { is_expected.to create_template('/etc/sysconfig/slapd').with(source: 'sysconfig_slapd.erb') }
    it { is_expected.to create_template('/etc/openldap/slapd.conf').with(owner: 'ldap', group: 'ldap') }
    it { is_expected.to create_systemd_unit('slapd.service') }
    it { is_expected.to enable_service('slapd') }
    it { is_expected.to start_service('slapd') }
  end

  context 'delete on ubuntu 24.04' do
    platform 'ubuntu', '24.04'

    recipe do
      openldap_service 'slapd' do
        action :delete
      end
    end

    it { is_expected.to stop_service('slapd') }
    it { is_expected.to disable_service('slapd') }
    it { is_expected.to delete_file('/etc/ldap/slapd.conf') }
    it { is_expected.to delete_file('/etc/default/slapd') }
  end
end
