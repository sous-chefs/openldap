describe_recipe 'openldap::server' do

  it 'runs slapd' do
    service("slapd").must_be_running
  end

  it 'sets the rootpw' do
    file("#{node['openldap']['dir']}/slapd.conf").must_include node['openldap']['rootpw']
  end

  it 'ldap references the ssl certs' do
    file("#{node['openldap']['dir']}/slapd.conf").must_include node['openldap']['ssl_cert']
    file("#{node['openldap']['dir']}/slapd.conf").must_include node['openldap']['ssl_key']
  end

  it 'places the ssl certs' do
    file(node['openldap']['ssl_cert']).must_exist
    file(node['openldap']['ssl_cert']).must_exist
  end
end
