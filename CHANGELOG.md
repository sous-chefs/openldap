# openldap Cookbook CHANGELOG

This file is used to list changes made in each version of the openldap cookbook.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

Accesslog Database and Overlay configuration.

- added accesslog database and overlay stanza into slapd.conf.erb template.

Added additional attributes.

- `default['openldap']['accesslog']['enabled']` to enable additional accesslog configuration.
- `default['openldap']['accesslog']['logdb']` specifies the suffix of the database.
- `default['openldap']['accesslog']['directory']` specifes the directory to store the accesslog database.
- `default['openldap']['accesslog']['index']` specifies the database index.
- `default['openldap']['accesslog']['logops']` specifies which type of operations to log.
- `default['openldap']['accesslog']['logbase']` specifies a set of operations that will only be logged if they occur under a specific subtree of the database.
- `default['openldap']['accesslog']['logold']` specifies a filter for matching against Deleted and Modified entries.
- `default['openldap']['accesslog']['logoldattr']` specify a list of attributes whose old contents are always logged in Modify and ModRDN requests that match any of the filters configured in logold.
- `default['openldap']['accesslog']['logpurge']` specify the maximum age for log entries to be retained in the database
- `default['openldap']['accesslog']['logsuccess']` if set to TRUE then log records will only be generated for successful requests.

## 6.1.4 - *2024-07-15*

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

## 6.1.3 - *2024-05-06*

## 6.1.2 - *2024-05-06*

Fix CI Files

## 6.1.1 - *2023-09-04*

## 6.1.0 - *2023-07-07*

Allow to toggle OSUSOL RPM repo configuration on openldap_install resource

## 6.0.13 - *2023-04-07*

Standardise files with files in sous-chefs/repo-management

## 6.0.12 - *2023-04-01*

## 6.0.11 - *2023-04-01*

Standardise files with files in sous-chefs/repo-management

## 6.0.10 - *2023-03-20*

Standardise files with files in sous-chefs/repo-management

## 6.0.9 - *2023-03-15*

Standardise files with files in sous-chefs/repo-management

## 6.0.8 - *2023-02-27*

## 6.0.7 - *2023-02-23*

Standardise files with files in sous-chefs/repo-management

## 6.0.6 - *2023-02-15*

Standardise files with files in sous-chefs/repo-management

## 6.0.5 - *2022-12-15*

Standardise files with files in sous-chefs/repo-management

## 6.0.4 - *2022-08-23*

Standardise files with files in sous-chefs/repo-management

## 6.0.3 - *2022-02-10*

- Standardise files with files in sous-chefs/repo-management

## 6.0.2 - *2022-02-08*

- Remove delivery folder

## 6.0.1 - *2021-08-30*

- Standardise files with files in sous-chefs/repo-management

## 6.0.0 - *2021-08-10*

- Enable `unified_mode` for Chef 17 compatiblity

## 5.0.1 - *2021-06-01*

- Standardise files with files in sous-chefs/repo-management

## 5.0.0 - *2020-12-14*

- Improve customization of server with additional attributes
- Add `default['openldap']['admin_cn']` for customizing the admin CN
- Add `default['openldap']['indexes']` for customizing the indexes configured
- Add `default['openldap']['user_attrs']` for customizing the user access attributes
- Cleanup template formatting
- Set `sensitive true` for `slapd.conf` template
- Fix EL8 systemd unit for slapd daemon
- Move platform attributes and resource methods to library helpers
- Add `install_client` and `install_server` properties to `openldap_install` resource
- Improve ChefSpec tests
- Automatically rebuild slapd.d configuration when slapd.conf is updated
- Documentation for `openldap_install` resource

## 4.3.0 - *2020-11-23*

- Add RHEL/CentOS 8 support

## 4.2.0 (2020-11-04)

### Changed

- Sous Chefs Adoption
- Update Changelog to Sous Chefs
- Update to use Sous Chefs GH workflow
- Update test-kitchen to Sous Chefs
- Update README to sous-chefs
- Update metadata.rb to Sous Chefs

### Fixed

- resolved cookstyle error: spec/unit/recipes/default_spec.rb:42:18 warning: `ChefDeprecations/DeprecatedChefSpecPlatform`
- resolved cookstyle error: spec/unit/recipes/default_spec.rb:59:18 warning: `ChefDeprecations/DeprecatedChefSpecPlatform`
- ChefSpec fixes
- Yamllint fixes
- MDL fixes
- Add proper support for Amazon Linux
- Fix CentOS dokken suite testing
- Restart slapd if the default file is updated
- Enable modulepath for centos
- Fix tls for Amazon Linux
- Fix testing on FreeBSD

### Added

- Additional InSpec tests

### Removed

- Remove EL6 testing and support

## 4.1.0 (2020-02-25)

- Use platform helpers where we can - [@tas50](https://github.com/tas50)
- Remove legacy metadata that isn't used - [@tas50](https://github.com/tas50)
- Testing updates and modernization - [@tas50](https://github.com/tas50)
- Add Github actions testing of style/unit - [@tas50](https://github.com/tas50)
- Require Chef 12.15+ - [@tas50](https://github.com/tas50)
- Update platforms we test on and fix ChefSpec deprecation warnings - [@tas50](https://github.com/tas50)

## 4.0.0 (2018-07-18)

- added support in syncrepl for ldaps and config options. This is a breaking change as it changes several of the attributes used to setup syncrepl. If you previously used the syncrepl functionality in this cookbook be sure to check the current attributes to see where changes are necessary before applying this new version of the cookbook.
- Update ChefSpecs to the latest platform releases

## 3.1.2 (2017-07-27)

- fixed slapd.conf file syntax
- parameterize dbconfig settings

## 3.1.1 (2017-06-14)

- remove extra by, invalid syntax that breaks non-admin read

## 3.1.0 (2017-05-30)

- Remove class_eval usage and require Chef 12.7+

## [v3.0.3](https://github.com/chef-cookbooks/openldap/tree/v3.0.3) (2017-04-04)

[Full Changelog](https://github.com/chef-cookbooks/openldap/compare/v3.0.2...v3.0.3)

- Break rhelish 6 and 7 sysconfig templates out separately [\#89](https://github.com/chef-cookbooks/openldap/pull/89) ([cheeseplus](https://github.com/cheeseplus))
- Fixing CentOS and Amazon Linux support [\#88](https://github.com/chef-cookbooks/openldap/pull/88) ([jpooler](https://github.com/jpooler))

## v3.0.2 (2017-03-27)

- Change `/var/cache/local/preseeding` resource configuration to be mode '0755'

## v3.0.1 (2017-03-27)

- Update metadata to improve search query on supermarket for ldap.
- Standardize license string in metadata.

## v3.0.0 (2017-03-16)

This version has several major breaking changes that you will need to be aware of.

- cn=config via slapd.d never worked and thus the 'support' has been removed - it may return but it will be a new feature
- All auth logic has been removed from this cookbook. This cookbook now only configures the server side of openldap. We highly recommend configuring LDAP auth using our sssd_ldap cookbook, which functions much better than the previous PAM config.
- A config hash have been added to add arbitrary files to the ldap.config and slapd.config files. This eliminates much of the need for forking this cookbook to meet your environment's needs. See the readme for detailed information on how these hashes are converted to ldap configs.
- Many attributes are no longer present or have had name/value changes
- There is now only one recipe and it is `default`
- Properly supporting all platforms listed as supported
- Adoption of `provider` and `consumer` terminology

### Other Changes

- Documented the current process for managing certs
- Remove old Ubuntu initial run steps from the Readme
- Ship with more sane logging levels
- Don't manage ssl out of the box.
- Remove a duplicate ERB that wasn't called anywhere
- Rearrange the attributes file to make more sense
- Updates to the provider setup with syncrepl to make it actually work
- Add new attributes to provide better control of replication
- Add unit and lint testing in Travis CI
- Add basic convergence Chefspec
- TLS config fixes, use uri over host+port, include client_config_hash in both config files
- Add new supermarket metadata
- Add chef_version metadata
- Resolve all cookstyle warnings
- Add maintainers files
- Fix recipe is expecting an attribute named "system_user", but attributes are configured to provide "system_acct".
- Add TLSCipherSuite to slapd.conf
- Remove node name from all configs
- Log a warning error if someone tries to use the default recipe since it doesn't do anything

## v2.2.0 (2015-04-16)

- Added support for FreeBSD
- Improved support for RHEL platforms
- Removed the attributes from the metadata.rb file since they were outdated

## v2.1.0 (2015-03-10)

- Resolve the one and only Food Critic warning
- Remove legacy LDAP Apache2 attributes that aren't used in this cookbook or in the Apache2 cookbook
- Add an attribute for schemas to enable in the slapd config
- Add an attribute for the modules to load in the slapd config
- Make the cn used an attribute

## v2.0.0 (2015-03-06)

- Added URI to the client config so clients can communicate with the LDAP server
- Change all package resource actions from upgrade -> install and introduce and attribute if you want to change it back. Upgrading openldap when a new package comes out is not a desired action on production systems.
- Update the "Generated by Chef for xyz" comment blocks in the config templates to be consistent. This will result in config changes / service restarts due to notification
- Install the most recent version of the Berkeley DB utils package. This adds support for Trusty and RHEL, but will result in a newer version of the bd-util package being installed on Precise systems.
- Added new attributes to set the cookbook and source path for the SSL keys and certs. This reduces the need to fork / modify this cookbook
- Added a new attribute for controlling the log level of the server
- Make the ldap client package an attribute with support for RHEL
- Fix the search logic in the slave recipe to not fail
- Converted the cookbook to platform_family to better support Ubuntu. This means the cookbook will no longer work on Chef versions prior to 0.10.10
- Updated Gemfile with up to date dependency versions
- Updated Contributing doc to match the current process
- Added a chefignore file to prevent ds_store files from ending up in /usr/local/bin
- Switched all modes to strings to preserve the leading 0
- Added a rubocop.yml file and resolved the majority of rubocop complaints
- Updated platforms in the kitchen.yml file

## v1.12.13 (2015-02-18)

- reverting OpenSSL module namespace change

## v1.12.12 (2015-02-17)

- Updating to work with latest openssl cookbook

## v1.12.10 (2014-04-09)

- [COOK-4239] - Service enable/start resource moved to end
- [COOK-4239] - Fix sslfiles + ubuntu fix

## v1.12.8 (2014-01-03)

Merged nildomain branch

## v1.12.6 (2014-01-03)

adding checks for node['domain'].nil? in attributes

## v1.12.4

- [COOK-3772] - nscd clears don't work
- [COOK-411] - Openldap authentication should validate server certificate

## v1.12.2

### Improvement

- OpenLDAP Cookbooks - add extra options

## u tv0.12.0

### New Feature

- Support out of band SSL certificates in openldap::server

### Bug

- Fix an issue where preseeding may fail if directory does not exist
- Do not try to set up as a slave
- Fix a typo in `ldap-ldap.conf.erb` template

## v0.11.4

### Bug

- Fix typo in default attributes

## v0.11.2

### Bug

- [COOK-2496]: openldap: rootpw is badly set in attributes file
- [COOK-2970]: openldap cookbook has foodcritic failures

## v0.11.0

- [COOK-1588] - general cleanup/improvements
- [COOK-1985] - attributes file has a search method

## v0.10.0

- [COOK-307] - create directory with attribute

## v0.9.4

- Initial/Current release
