# openldap_install

Install client and server packages for OpenLDAP

## Properties

| Name                 | Type    | Default    | Description                                             |
| -------------------- | ------- | ---------- | ------------------------------------------------------- |
| `package_action`     | Symbol  | `:install` | Package action to use                                   |
| `install_client`     | Boolean | `true`     | Install openldap client package(s)                      |
| `install_server`     | Boolean | `true`     | Install openldap server package(s)                      |
| `install_repository` | Boolean | `true`     | Install extra repository for client & server package(s) |

### Examples

Install both client and server packages:

```ruby
openldap_install 'default'
```

Only install client packages:

```ruby
openldap_install 'clients' do
  install_server false
end
```

Only install server packages:

```ruby
openldap_install 'servers' do
  install_client false
end
```
