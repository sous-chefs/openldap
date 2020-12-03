module Openldap
  module Cookbook
    module Helpers
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
