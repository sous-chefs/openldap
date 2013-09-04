describe_recipe 'openldap::server' do

  it 'runs slapd' do
    service("slapd").must_be_running
  end

  it 'sets the rootpw' do
    file("#{node['openldap']['dir']}/slapd.conf").must_include node['openldap']['rootpw']
  end

end
