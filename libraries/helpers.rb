# frozen_string_literal: true

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
        end
      end

      def openldap_db_package
        'db-util' if platform_family?('debian')
      end

      def openldap_client_package
        case node['platform_family']
        when 'rhel', 'fedora', 'amazon'
          'openldap-clients'
        when 'debian'
          'ldap-utils'
        when 'suse'
          'openldap2-client'
        end
      end

      def openldap_dir
        case node['platform_family']
        when 'rhel', 'fedora', 'suse', 'amazon'
          '/etc/openldap'
        when 'debian'
          '/etc/ldap'
        end
      end

      def openldap_run_dir
        case node['platform_family']
        when 'rhel', 'fedora', 'amazon'
          '/run/openldap'
        when 'suse'
          '/run/slapd'
        when 'debian'
          '/run/slapd'
        end
      end

      def openldap_db_dir
        '/var/lib/ldap'
      end

      def openldap_module_dir
        case node['platform_family']
        when 'rhel', 'fedora', 'suse', 'amazon'
          '/usr/lib64/openldap'
        when 'debian'
          '/usr/lib/ldap'
        end
      end

      def openldap_slapd_d_dir
        "#{openldap_dir}/slapd.d"
      end

      def openldap_system_acct
        platform_family?('debian') ? 'openldap' : 'ldap'
      end

      def openldap_system_group
        platform_family?('debian') ? 'openldap' : 'ldap'
      end

      def openldap_defaults_path
        case node['platform_family']
        when 'rhel', 'fedora', 'amazon'
          '/etc/sysconfig/slapd'
        when 'debian'
          '/etc/default/slapd'
        when 'suse'
          '/etc/sysconfig/openldap'
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
        end
      end

      def openldap_systemd_unit_content
        {
          Unit: {
            Description: 'OpenLDAP Server Daemon',
            After: 'syslog.target network-online.target',
          },
          Service: {
            Type: 'forking',
            PIDFile: '/run/openldap/slapd.pid',
            Environment: '"SLAPD_URLS=ldap:/// ldapi:///" "SLAPD_OPTIONS="',
            EnvironmentFile: '/etc/sysconfig/slapd',
            ExecStartPre: '/usr/libexec/openldap/check-config.sh',
            ExecStart: '/usr/sbin/slapd -u ldap -h ${SLAPD_URLS} $SLAPD_OPTIONS',
          },
          Install: {
            WantedBy: 'multi-user.target',
            Alias: 'openldap.service',
          },
        }
      end

      def openldap_systemd_unit_required?
        (platform_family?('rhel') && node['platform_version'].to_i >= 8) || platform_family?('fedora')
      end

      def openldap_slapd_d_dir?
        ::File.exist?(openldap_slapd_d_dir)
      end

      def openldap_default_basedn
        domain = node['domain']
        return 'dc=localdomain' if domain.nil? || domain.split('.').count < 2

        "dc=#{domain.split('.').join(',dc=')}"
      end

      def openldap_default_server
        domain = node['domain']
        return 'ldap.localdomain' if domain.nil? || domain.split('.').count < 2

        "ldap.#{domain}"
      end

      def openldap_default_modules
        %w(back_mdb)
      end

      def openldap_default_database
        'mdb'
      end
    end
  end
end
