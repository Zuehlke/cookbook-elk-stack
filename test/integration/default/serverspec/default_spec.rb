require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'java' do
  describe command('java -version') do
    its(:stderr) { should contain 'java version' }
  end
end

describe 'elasticsearch' do
  describe service('elasticsearch') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(9200) do
    it { should be_listening }
  end

  describe port(9300) do
    it { should be_listening }
  end

  it 'is accessible via http' do
    cmd = command('wget -qO- localhost:9200')
    expect(cmd.stdout).to include 'status" : 200'
  end

  it 'installed the head plugin' do
    cmd = command('wget -qO- localhost:9200/_plugin/head')
    expect(cmd.stdout).to include 'elasticsearch-head'
  end
end

describe 'nginx' do
  describe package('nginx') do
    it { should be_installed }
  end

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
  end
end

describe 'kibana' do

  it 'is configured with sv for init' do
    cmd = command('sv check kibana')
    expect(cmd.stdout).to include 'ok:'
  end

  describe service('kibana') do
    it { should be_running }
  end

  describe port(5601) do
    it { should be_listening }
  end

  it 'is accessible through nginx' do
    cmd = command('wget -qO- localhost:80/')
    expect(cmd.stdout).to include 'kibana'
  end
end

describe 'sysconfig' do
  it 'is configured with ipv6 disabled' do
    cmd = command('cat /proc/sys/net/ipv6/conf/all/disable_ipv6')
    expect(cmd.stdout).to contain '1'
  end
end

describe 'logstash' do
  it 'is configured with sv for init' do
    cmd = command('sv check logstash')
    expect(cmd.stdout).to include 'ok:'
  end

  describe service('logstash') do
    it { should be_running }
  end

  describe port(10514) do
    it { should be_listening.with('tcp') }
    it { should be_listening.with('udp') }
  end
end
