title "Default role td-agent plugin installation integration test suite"

describe file('/usr/sbin/td-agent-gem') do
  it { should exist }
end

describe command('/usr/sbin/td-agent-gem list | grep fluent-plugin-assert') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match ('fluent-plugin-assert') }
end

describe command('/usr/sbin/td-agent-gem list | grep fluent-plugin-systemd') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match ('fluent-plugin-systemd') }
  its('stdout') { should match ('1.0.1') }
end
