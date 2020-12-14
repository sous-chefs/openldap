property :package_action, Symbol, default: :install
property :install_client, [true, false], default: true, description: 'Install openldap client package(s)'
property :install_server, [true, false], default: true, description: 'Install openldap server package(s)'

action :install do
  package openldap_db_package do
    action new_resource.package_action
  end if openldap_db_package

  # the debian package needs a preseed file in order to silently install
  if platform_family?('debian')
    directory node['openldap']['preseed_dir'] do
      action :create
      recursive true
      mode '0755'
      owner 'root'
      group node['root_group']
    end

    cookbook_file "#{node['openldap']['preseed_dir']}/slapd.seed" do
      source 'slapd.seed'
      cookbook 'openldap'
      mode '0600'
      owner 'root'
      group node['root_group']
    end

    dpkg_autostart openldap_server_package do
      allow false
    end
  end

  # NOTE(ramereth): RHEL 8 doesn't include openldap-servers so we pull from the
  # OSUOSL which builds the latest Fedora release for EL8
  if platform_family?('rhel') && node['platform_version'].to_i >= 8
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
    response_file 'slapd.seed' if platform_family?('debian')
    action new_resource.package_action
  end if new_resource.install_server
end
