openldap Cookbok CHANGELOG
==========================
This file is used to list changes made in each version of the openldap cookbook.


v1.12.10 (2014-04-09)
---------------------
- [COOK-4239] - Service enable/start resource moved to end
- [COOK-4239] - Fix sslfiles + ubuntu fix


v1.12.8 (2014-01-03)
--------------------
Merged nildomain branch


v1.12.6 (2014-01-03)
--------------------
adding checks for node['domain'].nil? in attributes


v1.12.4
-------

- [COOK-3772] - nscd clears don't work
- [COOK-411]  - Openldap authentication should validate server certificate


v1.12.2
-------
### Improvement
- **[COOK-3699](https://tickets.opscode.com/browse/COOK-3699)** - OpenLDAP Cookbooks - add extra options


u tv0.12.0
-------
### New Feature
- **[COOK-3561](https://tickets.opscode.com/browse/COOK-3561)** - Support out of band SSL certificates in openldap::server

### Bug
- **[COOK-3548](https://tickets.opscode.com/browse/COOK-3548)** - Fix an issue where preseeding may fail if directory does not exist
- **[COOK-3543](https://tickets.opscode.com/browse/COOK-3543)** - Do not try to set up as a slave
- **[COOK-3351](https://tickets.opscode.com/browse/COOK-3351)** - Fix a typo in `ldap-ldap.conf.erb` template


v0.11.4
-------
### Bug
- **[COOK-3348](https://tickets.opscode.com/browse/COOK-3348)** - Fix typo in default attributes

v0.11.2
-------
### Bug
- [COOK-2496]: openldap: rootpw is badly set in attributes file
- [COOK-2970]: openldap cookbook has foodcritic failures

v0.11.0
-------
- [COOK-1588] - general cleanup/improvements
- [COOK-1985] - attributes file has a search method

v0.10.0
-------
- [COOK-307] - create directory with attribute

v0.9.4
-------
- Initial/Current release
