describe_recipe 'openldap::auth' do
  it 'can bind anonymously' do
    output = %x(/usr/bin/ldapwhoami -x 2>&1)
    assert_match /anonymous/, output
    assert_equal 0, $?.exitstatus
  end
end
