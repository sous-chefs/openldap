ldap_dir =
  case os.family
  when 'debian'
    '/etc/ldap'
  when 'redhat', 'amazon', 'fedora', 'suse'
    '/etc/openldap'
  when 'bsd'
    '/usr/local/etc/openldap'
  end

control 'type_provider' do
  describe file "#{ldap_dir}/slapd.conf" do
    its('content') { should match /moduleload\s+syncprov/ }
    its('content') { should match /overlay syncprov/ }
    its('content') { should match /syncprov-checkpoint 100 10/ }
    its('content') { should match /syncprov-sessionlog 100/ }
    its('content') { should match /access to attrs=userPassword,shadowLastChange\n\s+by group\.exact="cn=administrators,dc=example,dc=com" write\n\s+by dn="cn=syncrole,dc=example,dc=com" read/ }
    its('content') { should match /access to \*\n\s+by group\.exact="cn=administrators,dc=example,dc=com" write\n\s+by dn="cn=syncrole,dc=example,dc=com" read/ }
  end
end
