# openldap_service

Configures and manages the OpenLDAP `slapd` service.

## Actions

| Action    | Description                                      |
|-----------|--------------------------------------------------|
| `:create` | Writes configuration and enables/starts slapd.   |
| `:delete` | Stops slapd and removes managed configuration.   |

## Properties

| Property                    | Type            | Default                              | Description                         |
|-----------------------------|-----------------|--------------------------------------|-------------------------------------|
| `service_name`              | String          | name property                        | Service name.                       |
| `basedn`                    | String          | derived from node domain             | LDAP base DN.                       |
| `cn`                        | String          | `admin`                              | Root DN common name.                |
| `admin_cn`                  | String          | `administrators`                     | Admin group common name.            |
| `server`                    | String          | derived from node domain             | LDAP server hostname.               |
| `rootpw`                    | String, nil     | `nil`                                | Root password hash.                 |
| `loglevel`                  | String          | `sync config`                        | slapd log level.                    |
| `modules`                   | Array           | platform default                     | Modules to load.                    |
| `database`                  | String          | platform default                     | Backend database.                   |
| `dbconfig`                  | Hash            | Berkeley DB defaults                 | `dbconfig` settings.                |
| `schemas`                   | Array           | core/cosine/nis/inetorgperson        | Schema files to include.            |
| `indexes`                   | Array           | legacy defaults                      | Index definitions.                  |
| `user_attrs`                | String          | `userPassword,shadowLastChange`      | Protected user attributes.          |
| `ldaps_enabled`             | Boolean         | `false`                              | Listen on LDAPS.                    |
| `tls_enabled`               | Boolean         | `false`                              | Write TLS directives.               |
| `tls_cert`                  | String, nil     | `nil`                                | TLS certificate path.               |
| `tls_key`                   | String, nil     | `nil`                                | TLS key path.                       |
| `tls_cafile`                | String, nil     | `nil`                                | TLS CA file path.                   |
| `tls_ciphersuite`           | String, nil     | `nil`                                | TLS cipher suite.                   |
| `slapd_type`                | String, nil     | `nil`                                | `provider` or `consumer`.           |
| `slapd_provider`            | String, nil     | `nil`                                | Provider host for consumers.        |
| `slapd_replpw`              | String, nil     | `nil`                                | Replication password.               |
| `slapd_rid`                 | String, Integer | `102`                                | Replication ID.                     |
| `syncrepl_uri`              | String          | `ldap`                               | Replication URI scheme.             |
| `syncrepl_port`             | String, Integer | `389`                                | Replication port.                   |
| `syncrepl_cn`               | String          | `cn=syncrole`                        | Replication bind CN.                |
| `syncrepl_provider_config`  | Hash            | syncprov defaults                    | Provider config values.             |
| `syncrepl_consumer_config`  | Hash            | consumer defaults                    | Consumer config values.             |
| `server_config_hash`        | Hash            | `{ 'sizelimit' => 500 }`             | Additional slapd.conf directives.   |

## Examples

```ruby
openldap_install 'default'

openldap_service 'slapd' do
  rootpw '{SSHA}example'
end
```

```ruby
openldap_service 'slapd' do
  rootpw '{SSHA}example'
  tls_enabled true
  ldaps_enabled true
  tls_cert '/etc/ldap/ssl/ldap.example.com.crt'
  tls_key '/etc/ldap/ssl/ldap.example.com.key'
  tls_cafile '/etc/ldap/ssl/ldap.example.com.pem'
end
```
