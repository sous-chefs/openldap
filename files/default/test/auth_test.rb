describe_recipe 'openldap::auth' do
  it 'can bind anonymously' do
    output = `/usr/bin/ldapwhoami -x 2>&1`
    assert_match /anonymous/, output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
