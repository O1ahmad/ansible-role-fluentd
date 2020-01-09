title "Default role td-agent package service launch test suite"

describe service('td-agent') do
  it { should be_running }
  it { should be_enabled }
end
