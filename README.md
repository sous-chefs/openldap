# openldap Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/openldap.svg)](https://supermarket.chef.io/cookbooks/openldap)
[![CI State](https://github.com/sous-chefs/openldap/workflows/ci/badge.svg)](https://github.com/sous-chefs/openldap/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Configures a server to be an OpenLDAP provider or replication consumer. Also includes a recipe to install the client libs, but not to setup actual LDAP auth as there are several ways to do this. We recommend looking at the [sssd_ldap cookbook](https://github.com/chef-cookbooks/sssd_ldap).

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Ubuntu
- Debian
- FreeBSD
- RHEL/CentOS >= 7.0 *NOTE: RHEL 8 [removed support](https://www.redhat.com/en/blog/preparing-identity-management-red-hat-enterprise-linux-8) for openldap. We provide support via a repository provided by the [OSUOSL](https://osuosl.org).*
- Fedora
- openSUSE Leap

### Chef

- Chef 15.3+

### Cookbooks

- dpkg_autostart

## Attributes

This is not an exhaustive list of attributes as most are directly comparable to their OpenLDAP equivalents.

### Required

- `openldap['rootpw']`

This should be a password hash generated from slappasswd. The default slappasswd command will generate a salted SHA1 hash:

```shell
$ slappasswd -s "secretsauce"
{SSHA}6BjlvtSbVCL88li8IorkqMSofkLio58/
```

Set this via a node/role/env attribute or in a wrapper cookbook with an encrypted data_bag. OpenLDAP will fail to start if this is not set.

### Install/Upgrade

- `openldap['package_install_action']` - The action to be taken for all packages in the recipes. Defaults to :install, but can also be set to :upgrade to upgrade all packages referenced in the recipes.

### General configuration

- `openldap['schemas']` - Array of ldap schema file names to load
- `openldap['modules']` - Array of slapd modules names to load
- `openldap['indexes]' - Array of indexes to use
- `openldap['admin_cn']` - Admin CN name `administrators (default)`
- `openldap['user_attrs']` - User access attributes `userPassword,shadowLastChange (default)`

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
- `openldap['syncrepl_uri']` - `ldap (default) | ldaps`
- `openldap['syncrepl_port']` - `'389 (default) | 636'`
- `openldap['syncrepl_cn']` - the CN (only) of the user to use as binddn as consumer

The following syncrepl values are set by default, others can be added by setting the appropriate key value
pair in the `openldap['syncrepl_*_config]` (See the OpenLDAP Adminstrator Guide):

- `openldap']['syncrepl_provider_config']['overlay']` - defaults to 'syncprov'
- `openldap']['syncrepl_provider_config']['syncprov-checkpoint']` - defaults to '100 10'
- `openldap']['syncrepl_provider_config']['syncprov-sessionlog']` - defaults to '100'
- `openldap['syncrepl_consumer_config']['type']` - defaults to 'refreshAndPersist'
- `openldap['syncrepl_consumer_config']['interval']` - interval for the sync. Defaults to 1 day
- `openldap['syncrepl_consumer_config']['searchbase']` - calculated in recipe
- `openldap['syncrepl_consumer_config']['filter']` - search filter to use in the replication
- `openldap['syncrepl_consumer_config']['scope']` - defaults to 'sub'
- `openldap['syncrepl_consumer_config']['schemachecking']` - defaults to 'off'
- `openldap['syncrepl_consumer_config']['bindmethod']` - defaults to 'simple'
- `openldap['syncrepl_consumer_config']['binddn']` - calculated in recipe
- `openldap['syncrepl_consumer_config']['starttls']` - `yes | no (default)`
- `openldap['syncrepl_consumer_config']['credentials']` - defaults to `openldap['slapd_replpw']`

### Accesslog

Enabling Accesslog will require to include the accesslog.la module.

- add `node.default['openldap']['modules'] << 'accesslog'

Attributes related to Accesslog database and overlay configuration.

`openldap['accesslog']['enabled']` - add accesslog configuration true | false (default)
`openldap['accesslog']['logdb']` -  defaults to `"cn=accesslog"`
`openldap['accesslog']['directory']` - defaults to `'/var/log/'`
`openldap['accesslog']['index']` - defaults to `'reqStart,reqEnd,reqResult eq'`
`openldap['accesslog']['logops']` - defaults to `'writes'`
`openldap['accesslog']['logbase']` - not set by default
`openldap['accesslog']['logold']` - defaults to '(objectclass=*)'
`openldap['accesslog']['logoldattr']` - defaults to nil
`openldap['accesslog']['logpurge']` - defaults to '8+00:00 1+00:00' purges after 8 and checks daily.
`openldap['accesslog']['logsuccess']` - defaults to false

## Recipes

### default

Install and configure OpenLDAP (slapd).

## Resources

- [install](https://github.com/sous-chefs/openldap/blob/master/documentation/resource_openldap_install.md)

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
