module Openldap
  module Cookbook
    module Helpers
      def openldap_server_package
        case node['platform_family']
        when 'rhel', 'fedora', 'amazon'
          'openldap-servers'
        when 'debian'
          'slapd'
        when 'suse'
          'openldap2'
        when 'freebsd'
          'openldap-server'
        end
      end

      def openldap_db_package
        case node['platform_family']
        when 'rhel', 'amazon'
          'compat-db47' if node['platform_version'].to_i < 8
        when 'debian'
          'db-util'
        when 'freebsd'
          'libdbi'
        end
      end

      def openldap_client_package
        case node['platform_family']
        when 'rhel', 'fedora', 'amazon'
          'openldap-clients'
        when 'debian'
          'ldap-utils'
        when 'suse'
          'openldap2-client'
        when 'freebsd'
          'openldap-client'
        end
      end

      def openldap_dir
        case node['platform_family']
        when 'rhel', 'fedora', 'suse', 'amazon'
          '/etc/openldap'
        when 'debian'
          '/etc/ldap'
        when 'freebsd'
          '/usr/local/etc/openldap'
        end
      end

      def openldap_run_dir
        case node['platform_family']
        when 'rhel', 'fedora', 'amazon'
          '/var/run/openldap'
        when 'suse'
          '/run/slapd'
        when 'debian'
          '/var/run/slapd'
        when 'freebsd'
          '/var/run/openldap'
        end
      end

      def openldap_db_dir
        case node['platform_family']
        when 'rhel', 'fedora', 'suse', 'amazon'
          '/var/lib/ldap'
        when 'debian'
          '/var/lib/ldap'
        when 'freebsd'
          '/var/db/openldap-data'
        end
      end

      def openldap_module_dir
        case node['platform_family']
        when 'rhel', 'fedora', 'suse', 'amazon'
          '/usr/lib64/openldap'
        when 'debian'
          '/usr/lib/ldap'
        when 'freebsd'
          '/usr/local/libexec/openldap'
        end
      end

      def openldap_system_acct
        case node['platform_family']
        when 'rhel', 'fedora', 'suse', 'amazon', 'freebsd'
          'ldap'
        when 'debian'
          'openldap'
        end
      end

      def openldap_system_group
        case node['platform_family']
        when 'rhel', 'fedora', 'suse', 'amazon', 'freebsd'
          'ldap'
        when 'debian'
          'openldap'
        end
      end

      def openldap_defaults_path
        case node['platform_family']
        when 'rhel', 'fedora', 'amazon'
          '/etc/sysconfig/slapd'
        when 'debian'
          '/etc/default/slapd'
        when 'suse'
          '/etc/sysconfig/openldap'
        when 'freebsd'
          '/etc/rc.conf.d/slapd'
        end
      end

      def openldap_defaults_template
        case node['platform_family']
        when 'rhel', 'fedora', 'amazon'
          'sysconfig_slapd.erb'
        when 'debian'
          'default_slapd.erb'
        when 'suse'
          'sysconfig_openldap.erb'
        when 'freebsd'
          'rc_slapd.erb'
        end
      end

      def openldap_el8_systemd_unit
        {
          'Unit' => {
            'Description' => 'OpenLDAP Server Daemon',
            'After' => 'syslog.target network-online.target',
          },
          'Service' => {
            'Type' => 'forking',
            'PIDFile' => '/var/run/openldap/slapd.pid',
            'Environment' => '"SLAPD_URLS=ldap:/// ldapi:///" "SLAPD_OPTIONS="',
            'EnvironmentFile' => '/etc/sysconfig/slapd',
            'ExecStartPre' => '/usr/libexec/openldap/check-config.sh',
            'ExecStart' => '/usr/sbin/slapd -u ldap -h ${SLAPD_URLS} $SLAPD_OPTIONS',
          },
          'Install' => {
            'WantedBy' => 'multi-user.target',
            'Alias' => 'openldap.service',
          },
        }
      end
    end
  end
end
Chef::DSL::Recipe.include ::Openldap::Cookbook::Helpers
Chef::Resource.include ::Openldap::Cookbook::Helpers
