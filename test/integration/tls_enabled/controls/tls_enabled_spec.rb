control 'tls-enabled' do
  describe port '636' do
    it { should be_listening }
  end
end
