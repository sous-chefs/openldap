Description
===========

Configures a server to be an OpenLDAP master, OpenLDAP replication
slave, or OpenLDAP client.

Requirements
============

## Platform:

Ubuntu 10.04 was primarily used in testing this cookbook. Other Ubuntu
versions and Debian may work. Red Hat and derivatives are not fully
supported, but we take patches.

## Cookbooks:

* openssh
* nscd
* openssl (for slave recipe)

Attributes
==========

Be aware of the attributes used by this cookbook and adjust the
defaults for your environment where required, in
attributes/openldap.rb.

## Client node attributes

* `openldap[:basedn]` - basedn
* `openldap[:server]` - the LDAP server fully qualified domain name,
  default `'ldap'.node[:domain]`.

## Server node attributes

### Replication options

* `openldap[:slapd_type]` - master | slave
* `openldap[:slapd_rid]` - unique integer ID, required if type is slave.
* `openldap[:slapd_master]` - hostname of slapd master, attempts to
  search for slapd_type master.

### Advanced options

* `openldap[:slapd_schema]` - list of schema files which should be loaded
  (full path or filename without file extension for schema files in schema
  subdirectory)
* `openldap[:slapd_modules]` - list of slapd modules
* `openldap[:slapd_loglevel]` - loglevel for slapd, integers or names,
  see slapd.conf man page for more information
* `openldap[:slapd_sizelimit]` - default entry size limit for search queries
* `openldap[:slapd_tool-threads]` - maximum number of threads to use
  in tool mode, should be not greater than the number of processors

### Access control lists

`openldap[:slapd_acls]` defines the access control lists. It's a hash with
priority as key (lowest is the most important).

Every entry is a hash createing an access line in slapd.conf:

* `entry[:dn]` describes the dn which should match, nil means all
* `entry[:dntype]` matchtype for the dn, e.g. exact, base, regex, one, sub
* `entry[:filter]` filters entries like RFC 4515 (e.g.) ldapsearch;
  no value or nil results in '(objectClass=*)'
* `entry[:attrs]` comma-separated list of attributes the rules applies to.
* `entry[:access]` a priority hash with rules who has which privileges.

Every access entry is a hash with the following options:

* `access[:action]` allowed actions, e.g. read, write, +w
* `access[:control]` special parsing options (stop, break, continue), stop is
  the default
* To rights to special groups, set `access[:self]`, `access[:anonymous]`,
  `access[:users]` or other spe to true,
* To grant rights by other match types, set the test as key (e.g. dn.exact)
  and the test value as value

Examples:

```json
{
  "0": {
    "dn": "^(.+,)?uid=([^,]+),dc=example,dc=com$",
    "dntype": "regex",
    "access": {
      "0": {
        "dn.exact,expand": "uid=$2,dc=example,dc=com",
        "action": "write"
      }
    }
  }
}
```

Per default all data are readable by everyone and only the admin can modify.
The access to the user attributes is limit to admin, replication and
authentication:

```json
{
  "00": {
    "attrs": "userPassword,shadowLastChange",
    "access": {
      "00": { "group.exact": "cn=administrators,${basedn}", "action": "write" },
      "10": { "dn": "cn=syncrole,${basedn}", "action": "read" },
      "20": { "anonymous": true, "action": "auth" },
      "30": { "self": true, "action": "write" },
      "40": "none"
    }
  },
  "10": {
    "dn": "",
    "dntype": "base",
    "access": "read",
  },
  "20": {
    "access": {
      "00": { "group.exact": "cn=administrators,${basedn}", "action": "write" },
      "10": { "dn": "cn=syncrole,${basedn}", "action": "read" },
      "20": "read"
    }
  }
}
```

**Warning:** You may need to update these acls if you change your `basedn`.

See **slapd.access**(5) man page for more information and all supported options.

### Database configuration

`openldap[:slapd_databases]` is a hash with all databases of this openldap
server. Normally only one database - called default - is created. The key
inside this hash is only for internal identification and can be free choosen.

* `database[:type]` - backend type, e.g. hdb
* `database[:suffix]` - suffix of this backend, e.g. 'dc=example,dc=org'
* `database[:rootdn]` - administrator dn for this backend,
  e.g. 'cn=admin,dc=example,dc=org'
* `database[:rootpw]` - passwort for administrator dn
* `database[:direcoty]` - storage dirctory in file system
* `database[:lastmod]` - should slapd control meta attributes like
  modifyTimestamp automatically
* `database[:indexes]` - dictionary with index definition. key is the list for
  attributes (comma-separated), values are the required actions which should be
  possible via index (e.g. eq,pres,sub). You index name default for default
  values. Set index value to `true` or `''` to support default index actions.
  Set index value to `false` or `nil` to unset before defined value.

### Additional options

The slapd.conf config is devided into multiple parts. For every parts
additional (for the cookbook unknown) options can be set via special hashes:
`openldap[:slapd_options]` for global options and
`openldap[:slapd_databases][name][:options]` for database specific options.

The key of the hash is the name of the options in slapd.conf and the value
should be nil (option hidden), a string (single option) or a array with
strings (one line with option and value for entry in array).
The strings are not escaped. So a value with a blank can be escaped
by encapsulate with ".

See **slapd.conf**(5) man page for more information about escaping and all
configuration options.

## Apache configuration attributes

Attributes useful for Apache authentication with LDAP.

COOK-128 - set automatically based on openldap[:server] and
openldap[:basedn] if those attributes are set. openldap[:auth_bindpw]
remains nil by default as a default value is not easily predicted.

* `openldap[:auth_type]` - determine whether binddn and bindpw are
  required (openldap no, ad yes)
* `openldap[:auth_url]` - AuthLDAPURL
* `openldap[:auth_binddn]` - AuthLDAPBindDN
* `openldap[:auth_bindpw]` - AuthLDAPBindPassword

Recipes
=======

### auth

Sets up the system for using openldap for user authentication.

### default

Empty recipe, you may want client.

### client

Install the openldap client packages.

### server

Set up openldap to be a slapd server. Use this if your environment
would only have a single slapd server.

### master

Sets the `node['openldap']['slapd_type']` to master and then includes
the `openldap::server` recipe.

### slave

Sets the `node['openldap']['slapd_type']` to slave, then includes the
`openldap::server` recipe. If the node is running chef-solo, then the
`node['openldap']['slapd_replpw']` and
`node['openldap']['slapd_master']` attributes must be set in the JSON
attributes file passed to `chef-solo`.

Usage
=====

Edit Rakefile variables for SSL certificate.

On client systems,

    include_recipe "openldap::auth"

This will get the required packages and configuration for client
systems. This will be required on server systems as well, so this is a
good candidate for inclusion in a base role.

On server systems, if there's only one LDAP server, then use the
`openldap::server` recipe. If replication is required, use the
`openldap::master` and `openldap::slave` recipes instead.

When initially installing a brand new LDAP master server on Ubuntu
8.10, the configuration directory may need to be removed and recreated
before slapd will start successfully. Doing this programmatically may
cause other issues, so fix the directory manually :-).

    $ sudo slaptest -F /etc/ldap/slapd.d
    str2entry: invalid value for attributeType objectClass #1 (syntax 1.3.6.1.4.1.1466.115.121.1.38)
    => ldif_enum_tree: failed to read entry for /etc/ldap/slapd.d/cn=config/olcDatabase={1}bdb.ldif
    slaptest: bad configuration directory!

Simply remove the configuration, rerun chef-client. For some reason
slapd isn't getting started even though the service resource is
notified to start, so start it manually.

    $ sudo rm -rf /etc/ldap/slapd.d/ /etc/ldap/slapd.conf
    $ sudo chef-client
    $ sudo /etc/init.d/slapd start

### A note about certificates

Certificates created by the Rakefile are self signed. If you have a
purchased CA, that can be used. Be sure to update the certificate
locations in the templates as required. We suggest copying this
cookbook to the site-cookbooks for such modifications, so you can
still pull from our master for updates, and then merge your changes
in.

## New Directory:

If installing for the first time, the initial directory needs to be
created. Create an ldif file, and start populating the directory.

## Passwords:

Set the password, openldap[:rootpw] for the rootdn in the node's
attributes. This should be a password hash generated from slappasswd.
The default slappasswd command on Ubuntu 8.10 and Mac OS X 10.5 will
generate a SHA1 hash:

    $ slappasswd -s "secretsauce"
    {SSHA}6BjlvtSbVCL88li8IorkqMSofkLio58/

Set this by default in the attributes file, or on the node's entry in
the webui.

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)
Copyright:: 2009, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
