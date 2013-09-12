This cookbook includes support for running tests via Test Kitchen (1.0). This has some requirements.

1. You must be using the Git repository, rather than the downloaded cookbook from the Chef Community Site.
2. You must have Vagrant 1.1 installed.
3. You must have a "sane" Ruby 1.9.3 environment.

Once the above requirements are met, install the additional requirements:

  gem install bundle
  bundle install

  vagrant plugin install vagrant-berkshelf

You'll need to add some SSL certificates. For testing purposes, create dummy self-signed certs by running:
  mkdir files/default/ssl
  FQDN=ldap.example.com rake ssl_cert

Once the above are installed, you should be able to run Test Kitchen:

    kitchen list
    kitchen test
