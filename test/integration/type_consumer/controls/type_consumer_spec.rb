ldap_dir =
  case os.family
  when 'debian'
    '/etc/ldap'
  when 'redhat', 'amazon', 'fedora', 'suse'
    '/etc/openldap'
  when 'bsd'
    '/usr/local/etc/openldap'
  end

control 'type_consumer' do
  describe file "#{ldap_dir}/slapd.conf" do
    its('content') { should match %r{syncrepl rid=102\n\s+provider=ldap://ldap\.example\.com:389\n\s+type=refreshAndPersist\n\s+interval=01:00:00:00\n\s+searchbase="dc=example,dc=com"\n\s+filter="\(objectClass=\*\)"\n\s+scope=sub\n\s+schemachecking=off\n\s+bindmethod=simple\n\s+binddn="cn=syncrole,dc=example,dc=com"\n\s+starttls=no\n\s+credentials=""} }
  end
end
