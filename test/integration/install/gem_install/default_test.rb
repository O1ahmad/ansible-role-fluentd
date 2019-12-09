title "Default role gem installation integration test suite"

describe file('/usr/local/bin/fluentd') do
  it { should exist }
end

describe gem('fluentd') do
  it { should be_installed }
  its('version') { should eq '1.7.3' }
end
