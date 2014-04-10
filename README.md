openldap Cookbook
=================
Configures a server to be an OpenLDAP master, OpenLDAP replication slave, or OpenLDAP client.


Requirements
------------
### Platform
Ubuntu 10.04 was primarily used in testing this cookbook. Other Ubuntu versions and Debian may work. Red Hat and derivatives are not fully supported, but we take patches.

### Cookbooks
- openssh
- nscd
- openssl (for slave recipe)


Attributes
----------
Be aware of the attributes used by this cookbook and adjust the defaults for your environment where required, in `attributes/openldap.rb`.

### Client node attributes

- `openldap[:basedn]` - basedn
- `openldap[:server]` - the LDAP server fully qualified domain name, default `'ldap'.node[:domain]`.
- `openldap[:tls_enabled]` - specifies whether TLS will be used at all. Setting this to fals will result in your credentials being sent in clear-text.
- `openldap[:tls_checkpeer]` - specifies whether the client should verify the server's TLS certificate. Highly recommended to set tls_checkpeer to true for production uses in order to avoid man-in-the-middle attacks. Defaults to false for testing and backwards compatibility.
- `openldap[:pam_password]` - specifies the password change protocol to use. Defaults to md5.

### Server node attributes

- `openldap[:slapd_type]` - master | slave
- `openldap[:slapd_rid]` - unique integer ID, required if type is slave.
- `openldap[:slapd_master]` - hostname of slapd master, attempts to search for slapd_type master.
- `openldap[:manage_ssl]` - Whether or not this cookbook manages your SSL certificates.
   If set to `true`, this cookbook will expect your SSL certificates to be in files/default/ssl and will configure slapd appropriately.
   If set to `false`, you will need to provide your SSL certificates **prior** to this recipe being run. Be sure to set `openldap[:ssl_cert]` and `openldap[:ssl_key]` appropriately.
- `openldap[:ssl_cert]` - The full path to your SSL certificate.
- `openldap[:ssl_key]` - The full path to your SSL key.
- `openldap[:cacert]` - Your certificate authority's certificate (or intermediate authorities), if needed.

### Apache configuration attributes

Attributes useful for Apache authentication with LDAP.

COOK-128 - set automatically based on openldap[:server] and openldap[:basedn] if those attributes are set. openldap[:auth_bindpw] remains nil by default as a default value is not easily predicted.

- `openldap[:auth_type]` - determine whether binddn and bindpw are required (openldap no, ad yes)
- `openldap[:auth_url]` - AuthLDAPURL
- `openldap[:auth_binddn]` - AuthLDAPBindDN
- `openldap[:auth_bindpw]` - AuthLDAPBindPassword


Recipes
-------
### auth

Sets up the system for using openldap for user authentication.

### default

Empty recipe, you may want client.

### client

Install the openldap client packages.

### server

Set up openldap to be a slapd server. Use this if your environment would only have a single slapd server.

### master

Sets the `node['openldap']['slapd_type']` to master and then includes the `openldap::server` recipe.

### slave

Sets the `node['openldap']['slapd_type']` to slave, then includes the `openldap::server` recipe. If the node is running chef-solo, then the `node['openldap']['slapd_replpw']` and `node['openldap']['slapd_master']` attributes must be set in the JSON attributes file passed to `chef-solo`.


Usage
-----
Edit Rakefile variables for SSL certificate.

On client systems,

```ruby
include_recipe "openldap::auth"
```

This will get the required packages and configuration for client systems. This will be required on server systems as well, so this is a good candidate for inclusion in a base role.

On server systems, if there's only one LDAP server, then use the `openldap::server` recipe. If replication is required, use the `openldap::master` and `openldap::slave` recipes instead.

When initially installing a brand new LDAP master server on Ubuntu 8.10, the configuration directory may need to be removed and recreated before slapd will start successfully. Doing this programmatically may cause other issues, so fix the directory manually :-).

    $ sudo slaptest -F /etc/ldap/slapd.d
    str2entry: invalid value for attributeType objectClass #1 (syntax 1.3.6.1.4.1.1466.115.121.1.38)
    => ldif_enum_tree: failed to read entry for /etc/ldap/slapd.d/cn=config/olcDatabase={1}bdb.ldif
    slaptest: bad configuration directory!

For some reason slapd isn't getting started even though the service resource is notified to start, so start it manually.
Solution is to simply remove the configuration:

    $ sudo rm -rf /etc/ldap/slapd.d/ /etc/ldap/slapd.conf
    $ sudo chef-client
    $ sudo /etc/init.d/slapd start

Or in your wrapper cookbook rewind with ubuntu related fix:

    #Fix the wrong content of slapd.d dir on ubuntu 12.04
    chef_gem "chef-rewind"
    require 'chef/rewind'
    case node['platform']
    when 'ubuntu'
        rewind "package[slapd]" do
            response_file "slapd.seed"
            action :upgrade
            notifies :run, "execute[fix-ubuntu-slapdd]", :immediately
        end
    end
    #Removes slapd.d/cn=config and slapd.conf deployed from distribution. They will be re-created during the openldap recipe cooking.
    execute "fix-ubuntu-slapdd" do
        cmd =  "   test -d #{node['openldap']['dir']}/slapd.d && rm -rf #{node['openldap']['dir']}/slapd.d/cn=config"
        cmd << " ; test -d #{node['openldap']['dir']}/slapd.conf && rm -rf #{node['openldap']['dir']}/slapd.conf"
        cmd << " ; touch #{node['openldap']['dir']}/.fix-ubuntu-slapdd.done"
        command cmd
        ignore_failure true
        action :nothing
        not_if { ::File.exists?("#{node['openldap']['dir']}/.fix-ubuntu-slapdd.done") }
    end


### A note about certificates

Certificates created by the Rakefile are self signed. If you have a purchased CA, that can be used.

We provide two methods of managing SSL certificates, based off of `openldap[:manage_ssl]`.

If `openldap[:manage_ssl]` is `true`, then this cookbook manage your certificates itself, and will expect all certificates, intermediate certificates, and keys to be in the same file as defined in `openldap[:ssl_cert]`.

Use https://github.com/atomic-penguin/cookbook-certificate cookbook for advanced certificate deployment or use wrapper cookbook with following code to source ssl files from the wrapper cookbook folder structure:

    r = resources("cookbook_file[#{node['openldap']['ssl_cert']}]")
    r.cookbook('NAME OF YOUR WRAPPER COOKBOK')

    r = resources("cookbook_file[#{node['openldap']['ssl_key']}]")
    r.cookbook('NAME OF YOUR WRAPPER COOKBOK')

Be sure to update the certificate locations in the templates as required. We suggest copying this cookbook to the site-cookbooks for such modifications, so you can still pull from our master for updates, and then merge your changes in.

However, if `openldap[:manage_ssl]` is `false`, then you will need to place the SSL certificates on the client file system **prior** to this cookbook being run. This provides you the flexibility to provide the same set of SSL certificates for multiple uses as well as in one place across your environment, but you will need to manage them.
- Set `openldap[:ssl-cert]`, `openldap[:ssl_key]`, and `openldap[:cacert]` appropriately.
- Ensure that that user openldap can access these files. Watch out for apparmor and SELinux if you are placing your SSL certificates in a non-default location.

### New Directory
If installing for the first time, the initial directory needs to be created. Create an ldif file, and start populating the directory.

### Passwords
Set the password, openldap[:rootpw] for the rootdn in the node's attributes. This should be a password hash generated from slappasswd. The default slappasswd command on Ubuntu 8.10 and Mac OS X 10.5 will generate a SHA1 hash:

    $ slappasswd -s "secretsauce"
    {SSHA}6BjlvtSbVCL88li8IorkqMSofkLio58/

Set this by default in the attributes file, or on the node's entry in the webui.


License & Authors
-----------------
- Author:: Joshua Timberman (<joshua@opscode.com>)

```text
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
```
