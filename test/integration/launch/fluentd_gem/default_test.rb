title "Default role fluentd gem service launch test suite"

describe service('fluentd') do
  it { should be_running }
  it { should be_enabled }
end
