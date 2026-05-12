# frozen_string_literal: true

provides :openldap_service
unified_mode true

include Openldap::Cookbook::Helpers

property :service_name, String, name_property: true
property :basedn, String, default: lazy { openldap_default_basedn }
property :cn, String, default: 'admin'
property :admin_cn, String, default: 'administrators'
property :server, String, default: lazy { openldap_default_server }
property :rootpw, [String, nil], sensitive: true
property :loglevel, String, default: 'sync config'
property :modules, Array, default: lazy { openldap_default_modules }
property :database, String, default: lazy { openldap_default_database }
property :dbconfig, Hash, default: {
  'set_cachesize' => '0 31457280 0',
  'set_lk_max_objects' => '1500',
  'set_lk_max_locks' => '1500',
  'set_lk_max_lockers' => '1500',
}
property :schemas, Array, default: %w(core.schema cosine.schema nis.schema inetorgperson.schema)
property :indexes, Array, default: [
  'default pres,eq,approx,sub',
  'objectClass eq',
  'cn,ou,sn,uid,l,mail,gecos,memberUid,description',
  'loginShell,homeDirectory pres,eq,approx',
  'uidNumber,gidNumber pres,eq',
]
property :user_attrs, String, default: 'userPassword,shadowLastChange'
property :ldaps_enabled, [true, false], default: false
property :tls_enabled, [true, false], default: false
property :tls_cert, [String, nil]
property :tls_key, [String, nil]
property :tls_cafile, [String, nil]
property :tls_ciphersuite, [String, nil]
property :slapd_type, [String, nil], equal_to: [nil, 'provider', 'consumer']
property :slapd_provider, [String, nil]
property :slapd_replpw, [String, nil], sensitive: true
property :slapd_rid, [String, Integer], default: 102
property :syncrepl_uri, String, default: 'ldap'
property :syncrepl_port, [String, Integer], default: '389'
property :syncrepl_cn, String, default: 'cn=syncrole'
property :syncrepl_provider_config, Hash, default: {
  'overlay' => 'syncprov',
  'syncprov-checkpoint' => '100 10',
  'syncprov-sessionlog' => '100',
}
property :syncrepl_consumer_config, Hash, default: {
  'type' => 'refreshAndPersist',
  'interval' => '01:00:00:00',
  'searchbase' => nil,
  'filter' => '"(objectClass=*)"',
  'scope' => 'sub',
  'schemachecking' => 'off',
  'bindmethod' => 'simple',
  'binddn' => nil,
  'starttls' => 'no',
  'credentials' => nil,
}
property :server_config_hash, Hash, default: { 'sizelimit' => 500 }

action_class do
  include Openldap::Cookbook::Helpers

  def template_config
    consumer_config = new_resource.syncrepl_consumer_config.dup
    consumer_config['searchbase'] ||= "\"#{new_resource.basedn}\""
    consumer_config['binddn'] ||= "\"#{new_resource.syncrepl_cn},#{new_resource.basedn}\""
    consumer_config['credentials'] ||= "\"#{new_resource.slapd_replpw}\""

    {
      basedn: new_resource.basedn,
      cn: new_resource.cn,
      admin_cn: new_resource.admin_cn,
      server: new_resource.server,
      rootpw: new_resource.rootpw,
      loglevel: new_resource.loglevel,
      modules: new_resource.modules,
      database: new_resource.database,
      dbconfig: new_resource.dbconfig,
      schemas: new_resource.schemas,
      indexes: new_resource.indexes,
      user_attrs: new_resource.user_attrs,
      ldaps_enabled: new_resource.ldaps_enabled,
      tls_enabled: new_resource.tls_enabled,
      tls_cert: new_resource.tls_cert,
      tls_key: new_resource.tls_key,
      tls_cafile: new_resource.tls_cafile,
      tls_ciphersuite: new_resource.tls_ciphersuite,
      slapd_type: new_resource.slapd_type,
      slapd_provider: new_resource.slapd_provider,
      slapd_rid: new_resource.slapd_rid,
      syncrepl_uri: new_resource.syncrepl_uri,
      syncrepl_port: new_resource.syncrepl_port,
      syncrepl_cn: new_resource.syncrepl_cn,
      syncrepl_provider_config: new_resource.syncrepl_provider_config,
      syncrepl_consumer_config: consumer_config,
      server_config_hash: new_resource.server_config_hash,
    }
  end
end

action :create do
  template openldap_defaults_path do
    cookbook 'openldap'
    source openldap_defaults_template
    variables(config: template_config)
    notifies :restart, "service[#{new_resource.service_name}]"
  end

  systemd_unit "#{new_resource.service_name}.service" do
    content openldap_systemd_unit_content
    action :create
  end if openldap_systemd_unit_required?

  template "#{openldap_dir}/slapd.conf" do
    cookbook 'openldap'
    source 'slapd.conf.erb'
    variables(
      config: template_config,
      paths: {
        dir: openldap_dir,
        run_dir: openldap_run_dir,
        db_dir: openldap_db_dir,
        module_dir: openldap_module_dir,
      }
    )
    mode '0640'
    owner openldap_system_acct
    group openldap_system_group
    sensitive true
    notifies :restart, "service[#{new_resource.service_name}]", :immediately
    notifies :run, "execute[rebuild #{new_resource.service_name} config]", :immediately if lazy { openldap_slapd_d_dir? }
  end

  service new_resource.service_name do
    action [:enable, :start]
  end

  execute "rebuild #{new_resource.service_name} config" do
    command "rm -rf #{openldap_slapd_d_dir}/* && slaptest -f #{openldap_dir}/slapd.conf -F #{openldap_slapd_d_dir}"
    user openldap_system_acct
    group openldap_system_group
    action :nothing
    notifies :restart, "service[#{new_resource.service_name}]", :immediately
  end
end

action :delete do
  service new_resource.service_name do
    action [:stop, :disable]
  end

  systemd_unit "#{new_resource.service_name}.service" do
    action :delete
  end if openldap_systemd_unit_required?

  file "#{openldap_dir}/slapd.conf" do
    action :delete
  end

  file openldap_defaults_path do
    action :delete
  end
end
