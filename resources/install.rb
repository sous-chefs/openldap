# frozen_string_literal: true

provides :openldap_install
unified_mode true

property :package_action, Symbol, default: :install
property :install_client, [true, false], default: true, description: 'Install OpenLDAP client package(s)'
property :install_server, [true, false], default: true, description: 'Install OpenLDAP server package(s)'
property :install_repository, [true, false], default: true, description: 'Install extra repository for package(s)'
property :preseed_dir, String, default: '/var/cache/local/preseeding', description: 'Directory for Debian slapd preseed data'

action_class do
  include Openldap::Cookbook::Helpers

  def slapd_seed
    <<~SEED
      slapd	slapd/password1	password
      slapd	slapd/internal/adminpw	password
      slapd	slapd/password2	password
      slapd	slapd/allow_ldap_v2	boolean	false
      slapd	slapd/password_mismatch	note
      slapd	slapd/suffix_change	boolean	false
      slapd	slapd/fix_directory	boolean	true
      slapd	slapd/invalid_config	boolean	true
      slapd	slapd/slave_databases_require_updateref	note
      slapd	shared/organization	string	monkey
      slapd	slapd/upgrade_slapcat_failure	note
      slapd	slapd/dump_database_destdir	string	/var/backups/slapd-VERSION
      slapd	slapd/autoconf_modules	boolean	true
      slapd	slapd/purge_database	boolean	false
      slapd	slapd/domain	string	monkey.com
      slapd	slapd/backend	select	BDB
      slapd	slapd/no_configuration	boolean	false
      slapd	slapd/migrate_ldbm_to_bdb	boolean	true
      slapd	slapd/move_old_database	boolean	true
      slapd	slapd/dump_database	select	when needed
      slapd	slapd/upgrade_slapadd_failure	note
    SEED
  end
end

action :install do
  package openldap_db_package do
    action new_resource.package_action
  end if openldap_db_package

  if platform_family?('debian')
    directory new_resource.preseed_dir do
      recursive true
      mode '0755'
      owner 'root'
      group node['root_group']
    end

    file "#{new_resource.preseed_dir}/slapd.seed" do
      content slapd_seed
      mode '0600'
      owner 'root'
      group node['root_group']
      notifies :run, 'execute[preseed slapd]', :immediately
    end

    execute 'preseed slapd' do
      command "debconf-set-selections #{new_resource.preseed_dir}/slapd.seed"
      action :nothing
    end

    dpkg_autostart openldap_server_package do
      allow false
    end
  end

  if new_resource.install_repository && platform_family?('rhel') && node['platform_version'].to_i >= 8
    yum_repository 'osuosl-openldap' do
      baseurl 'https://ftp.osuosl.org/pub/osl/repos/yum/$releasever/openldap/$basearch'
      gpgkey 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl'
      description 'OSUOSL OpenLDAP repository'
      gpgcheck true
      enabled true
    end
  end

  package openldap_client_package do
    action new_resource.package_action
  end if new_resource.install_client

  package openldap_server_package do
    action new_resource.package_action
  end if new_resource.install_server
end

action :remove do
  package openldap_server_package do
    action :remove
  end if new_resource.install_server

  package openldap_client_package do
    action :remove
  end if new_resource.install_client

  yum_repository 'osuosl-openldap' do
    action :remove
  end if new_resource.install_repository && platform_family?('rhel') && node['platform_version'].to_i >= 8

  file "#{new_resource.preseed_dir}/slapd.seed" do
    action :delete
  end if platform_family?('debian')

  directory new_resource.preseed_dir do
    recursive true
    action :delete
  end if platform_family?('debian')

  package openldap_db_package do
    action :remove
  end if openldap_db_package
end
