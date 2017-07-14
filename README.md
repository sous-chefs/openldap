# openldap Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/openldap.svg?branch=master)](http://travis-ci.org/chef-cookbooks/openldap) [![Cookbook Version](https://img.shields.io/cookbook/v/openldap.svg)](https://supermarket.chef.io/cookbooks/openldap)

Configures a server to be an OpenLDAP master or replication slave. Also includes a recipe to install the client libs, but not to setup actual LDAP auth as there are several ways to do this. We recommend looking at our [sssd_ldap cookbook](https://github.com/chef-cookbooks/sssd_ldap)

## Requirements

### Platforms

- Ubuntu
- Debian
- FreeBSD
- RHEL/CentOS
- Fedora
- openSUSE Leap

### Chef

- Chef 12.7+

### Cookbooks

- dpkg_autostart

## Attributes

This is not an exhaustive list of attributes as most are directly comparable to their OpenLDAP equivalents.

### Required

- `openldap['rootpw']`

This should be a password hash generated from slappasswd. The default slappasswd command will generate a salted SHA1 hash:

```
$ slappasswd -s "secretsauce"
{SSHA}6BjlvtSbVCL88li8IorkqMSofkLio58/
```

Set this via a node/role/env attribute or in a wrapper cookbook with an encrypted data_bag. OpenLDAP will fail to start if this is not set.

### Install/Upgrade

- `openldap['package_install_action']` - The action to be taken for all packages in the recipes. Defaults to :install, but can also be set to :upgrade to upgrade all packages referenced in the recipes.

### General configuration

- `openldap['schemas']` - Array of ldap schema file names to load
- `openldap['modules']` - Array of slapd modules names to load

### TLS/SSL

If `openldap['ldaps_enabled']` or `openldap['tls_enabled']` are set, then `openldap['tls_cert']` and `openldap['tls_key']` must also be set and the files must exist prior to execution. Depending on the certificates, `openldap['tls_cafile']` may also need to be set. See the test cookbook for an example.

- `openldap['ldaps_enabled']` - listen on LDAPS (636) true | false (default)
- `openldap['tls_enabled']` - true | false (default)
- `openldap['tls_cert']` - full path to your SSL certificate
- `openldap['tls_key']` - full path to your SSL key
- `openldap['tls_cafile']` - full path to your CA certificate (or intermediate authorities), if needed.
- `openldap['tls_ciphersuite']` - OpenSSL cipher suite specification to use, defaults to none (use system default)

### Replication

Attributes related to replication (syncrepl). Only used if a provider or consumer.

- `openldap['slapd_type']` - `'provider' | 'consumer'`, default is `nil`
- `openldap['slapd_provider']` - hostname of slapd provider
- `openldap['slapd_replpw']` - replication password
- `openldap['slapd_rid']` - unique integer ID, required if type is consumer
- `openldap['syncrepl_interval']` - interval for the sync. Defaults to 1 day
- `openldap['syncrepl_type']` - defaults to 'refreshAndPersist'
- `openldap['syncrepl_filter']` - search filter to use in the replication
- `openldap['syncrepl_use_tls']` - `yes | no (default)`
- `openldap['syncrepl_cn']` - the CN (only) of the user to use as binddn as consumer

## Recipes

### default

Install and configure OpenLDAP (slapd).

## Maintainers

This cookbook is maintained by Chef's Community Cookbook Engineering team. Our goal is to improve cookbook quality and to aid the community in contributing to cookbooks. To learn more about our team, process, and design goals see our [team documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/COOKBOOK_TEAM.MD). To learn more about contributing to cookbooks like this see our [contributing documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/CONTRIBUTING.MD), or if you have general questions about this cookbook come chat with us in #cookbok-engineering on the [Chef Community Slack](http://community-slack.chef.io/)

## License

**Copyright:** 2008-2017, Chef Software, Inc.

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
