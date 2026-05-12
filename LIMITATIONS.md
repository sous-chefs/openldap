# Limitations

## Package Availability

OpenLDAP is installed from distribution packages by default. On RHEL-family platforms where
`openldap-servers` is absent, the `openldap_install` resource can enable the OSUOSL OpenLDAP
repository.

### APT (Debian/Ubuntu)

* Debian 12: distribution `slapd`, `ldap-utils`, and `db-util` packages are available.
* Ubuntu 22.04 and 24.04: distribution `slapd`, `ldap-utils`, and `db-util` packages are available.
* Symas OpenLDAP 2.6 LTS also publishes packages for Debian 11, Debian 12, Ubuntu 22.04, and Ubuntu 24.04.

### DNF/YUM (RHEL family)

* AlmaLinux/Rocky/Oracle/RHEL 8 compatible platforms are supported by the cookbook.
* RHEL 8 and newer removed `openldap-servers` from base distribution repositories; this cookbook uses the OSUOSL repository when `install_repository true`.
* Amazon Linux 2023 and Fedora use distribution packages where available.
* Symas OpenLDAP 2.6 LTS publishes packages for RHEL 8 and RHEL 9.

### Zypper (SUSE)

* openSUSE Leap 15 uses distribution `openldap2` and `openldap2-client` packages.
* Symas OpenLDAP 2.6 LTS publishes packages for SLES 15.6.

## Architecture Limitations

* Distribution package architecture support follows each distribution repository.
* The OSUOSL repository URL uses `$basearch`; package availability depends on OSUOSL publishing for that architecture.

## Source/Compiled Installation

Source installation is not implemented. This cookbook manages packaged OpenLDAP only.

## Known Issues

* RHEL-family server installation depends on an extra repository for platforms that do not ship `openldap-servers`.
* RHEL-family 9 platforms are not currently in the supported test matrix because the OSUOSL `openldap-servers` packages conflict with protected system packages in CI.
* This migration removes the recipe and node attribute API. Use `openldap_install` and `openldap_service` properties instead.
