require 'spec_helper'

describe package('httpd'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('httpd'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe service('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

describe service('org.apache.httpd'), :if => os[:family] == 'darwin' do
  it { should be_enabled }
  it { should be_running }
end

describe port(9200) do
  it { should be_listening }
end

describe port(5601) do
  it { should be_listening }
end
describe port(5000) do
  it { should be_listening }
end

describe service('elasticsearch-service-x64') do
  it { should be_installed }
end
describe service('logstash') do
  it { should be_installed }
end

describe service('kibana') do
  it { should be_running }
end
describe service('kibana') do
  it { should be_installed }
end

describe service('elasticsearch-service-x64') do
  it { should be_running }
end
describe service('logstash') do
  it { should be_running }
end
