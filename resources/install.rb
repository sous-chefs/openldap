property :package_action, Symbol, default: :install

action :install do
  if db_package
    package db_package do
      action new_resource.package_action
    end
  end

  # the debian package needs a preseed file in order to silently install
  if node['platform_family'] == 'debian'
    package 'ldap-utils'

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

    dpkg_autostart server_package do
      allow false
    end
  end

  package server_package do
    response_file 'slapd.seed' if node['platform_family'] == 'debian'
    action new_resource.package_action
  end
end

action_class do
  def server_package
    case node['platform_family']
    when 'debian'
      'slapd'
    when 'rhel', 'fedora'
      'openldap-servers'
    when 'freebsd'
      'openldap-server'
    when 'suse'
      'openldap2'
    end
  end

  def db_package
    case node['platform_family']
    when 'debian'
      'db-util'
    when 'rhel'
      node['platform_version'].to_i >= 7 && !platform?('amazon') ? 'compat-db47' : 'db4-utils'
    when 'freebsd'
      'libdbi'
    end
  end
end
