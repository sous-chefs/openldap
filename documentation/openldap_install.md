# openldap_install

Installs or removes OpenLDAP packages and optional repository/preseed artifacts.

## Actions

| Action     | Description                                   |
|------------|-----------------------------------------------|
| `:install` | Installs packages and supporting artifacts.   |
| `:remove`  | Removes packages and supporting artifacts.    |

## Properties

| Property             | Type    | Default                         | Description                       |
|----------------------|---------|---------------------------------|-----------------------------------|
| `package_action`     | Symbol  | `:install`                      | Package action for install.       |
| `install_client`     | Boolean | `true`                          | Install client packages.          |
| `install_server`     | Boolean | `true`                          | Install server packages.          |
| `install_repository` | Boolean | `true`                          | Enable the OSUOSL repo if needed. |
| `preseed_dir`        | String  | `/var/cache/local/preseeding`   | Debian slapd preseed directory.   |

## Examples

```ruby
openldap_install 'default'
```

```ruby
openldap_install 'client only' do
  install_server false
end
```
