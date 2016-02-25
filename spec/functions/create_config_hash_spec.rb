require 'spec_helper'

describe 'create_config_hash' do
  before(:each) do
    Puppet::Parser::Functions.function(:node_default_instance_directory)
  end

  describe 'build hashes for config generation' do
    it do
      should run.with_params({
        "github-oauth" => {
          'github.com' => 'token'
        },
        "process-timeout" => 500,
        "github-protocols" => ['ssh', 'https']
      }, :vagrant, :present).and_return({
        "'github-oauth'.'github.com'-vagrant-create" => {
          :value  => "token",
          :user   => "vagrant",
          :ensure => 'present',
          :entry  => "'github-oauth'.'github.com'"
        },
        "process-timeout-vagrant-create" => {
          :value  => 500,
          :user   => "vagrant",
          :ensure => 'present',
          :entry  => "process-timeout"
        },
        "github-protocols-vagrant-create" => {
          :value  => "ssh https",
          :user   => "vagrant",
          :ensure => 'present',
          :entry  => "github-protocols"
        }
      })
    end
  end

  describe 'removes parameters' do
    it do
      should run.with_params(['github-oauth.github.com', 'process-timeout'], :vagrant, :absent).and_return({
        "github-oauth.github.com-vagrant-remove" => {
          :user   => "vagrant",
          :ensure => 'absent',
          :entry  => "github-oauth.github.com"
        },
        "process-timeout-vagrant-remove" => {
          :user   => "vagrant",
          :ensure => 'absent',
          :entry  => "process-timeout"
        }
      })
    end
  end
end
