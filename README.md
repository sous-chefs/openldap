# openldap Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/openldap.svg?branch=master)](http://travis-ci.org/chef-cookbooks/openldap) [![Cookbook Version](https://img.shields.io/cookbook/v/openldap.svg)](https://supermarket.chef.io/cookbooks/openldap)

Configures a server to be an OpenLDAP master or replication slave. Also includes a recipe to install the client libs, but not to setup actual LDAP auth as there are several ways to do this. We recommend looking at our [sssd_ldap cookbook](https://github.com/chef-cookbooks/sssd_ldap)

## Requirements

### Platforms

- Ubuntu 12.04+
- Debian
- FreeBSD 10
- RHEL and derivatives

### Chef

- Chef 11+

### Cookbooks

- openssl (for slave recipe)
- freebsd

## Attributes

### Overall install attributes

- `openldap['package_install_action']` - The action to be taken for all packages in the recipes. Defaults to :install, but can also be set to :upgrade to upgrade all packages referenced in the recipes.

### Server node attributes

- `openldap['schemas']` - Array of ldap schema file names to load
- `openldap['modules']` - Array of slapd modules names to load
- `openldap['slapd_type']` - master | slave
- `openldap['slapd_rid']` - unique integer ID, required if type is slave.
- `openldap['slapd_master']` - hostname of slapd master, attempts to search for slapd_type master.
- `openldap['syncrepl_filter']` - The search filter to use in the replication
- `openldap['syncrepl_interval']` - The interval for the sync. Defaults to 1 day
- `openldap['database']` - Preferred database backend, defaults to HDB or MDB (for FreeBSD).
- `openldap['manage_ssl']` - Whether or not this cookbook manages your SSL certificates. If set to `true`, this cookbook will expect your SSL certificates to be in files/default/ssl and will configure slapd appropriately. If set to `false`, you will need to provide your SSL certificates **prior** to this recipe being run. Be sure to set `openldap['ssl_cert']` and `openldap['ssl_key']` appropriately.
- `openldap['ssl_cert']` - The full path to your SSL certificate.
- `openldap['ssl_key']` - The full path to your SSL key.
- `openldap['ssl_cert_source_cookbook']` - The cookbook to find the ssl cert. Defaults to this cookbook
- `openldap['ssl_cert_source_path']` - The path in the cookbook to find the ssl cert file.
- `openldap['ssl_key_source_cookbook']` - The cookbook to find the ssl key. Defaults to this cookbook
- `openldap['ssl_key_source_path']` - The path in the cookbook to find the ssl key file.
- `openldap['ssl_ciphersuite']` - The OpenSSL cipher suite specification to use. Defaults to none (use system default)
- `openldap['cafile']` - Your certificate authority's certificate (or intermediate authorities), if needed.

## Recipes

### default

Empty placeholder recipe.

### client

Install the openldap client packages.

### server

Set up openldap to be a slapd server. Use this if your environment would only have a single slapd server.

### master

Sets the `node['openldap']['slapd_type']` to master and then includes the `openldap::server` recipe.

### slave

Sets the `node['openldap']['slapd_type']` to slave, then includes the `openldap::server` recipe. If the node is running chef-solo, then the `node['openldap']['slapd_replpw']` and `node['openldap']['slapd_master']` attributes must be set in the JSON attributes file passed to `chef-solo`.

## Usage

If there's only on LDAP server, then use the `openldap::server` recipe. If replication is required, use the `openldap::master` and `openldap::slave` recipes instead.

### A note about certificates

Certificates created by the Rakefile are self signed. If you have a purchased CA, that can be used.

We provide two methods of managing SSL certificates, based off of `openldap['manage_ssl']`.

If `openldap['manage_ssl']` is `true`, then this cookbook manage your certificates itself, and will expect all certificates, intermediate certificates, and keys to be in the same file as defined in `openldap['ssl_cert']`. To prevent forking this cookbook you can provide the cookbook that contains the cert files using the `openldap['ssl_cert_source_cookbook']` and `openldap['ssl_key_source_cookbook']` attributes. By default they expect the files to exist within this cookbook.

If `openldap['manage_ssl']` is `false`, then you will need to place the SSL certificates on the client file system **prior** to this cookbook being run. This provides you the flexibility to provide the same set of SSL certificates for multiple uses as well as in one place across your environment, but you will need to manage them.

- Set `openldap['ssl_cert']`, `openldap['ssl_key']`, and `openldap['cafile']` appropriately.
- Ensure that that user openldap can access these files. Watch out for apparmor and SELinux if you are placing your SSL certificates in a non-default location.

### New LDAP Directory

If installing for the first time, the initial directory needs to be created. Create an ldif file, and start populating the directory.

### Passwords

Set the password, openldap['rootpw'] for the rootdn in the node's attributes. This should be a password hash generated from slappasswd. The default slappasswd command on Ubuntu 8.10 and Mac OS X 10.5 will generate a SHA1 hash:

```
$ slappasswd -s "secretsauce"
{SSHA}6BjlvtSbVCL88li8IorkqMSofkLio58/
```

Set this by default in the attributes file, or on the node's entry in the webui.

## License & Authors

**Author:** Cookbook Engineering Team ([cookbooks@chef.io](mailto:cookbooks@chef.io))

**Copyright:** 2008-2016, Chef Software, Inc.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
