require 'spec_helper'

describe 'composer::config::entry', :type => :define do
  let(:title) { '::composer::config::entry' }
  let(:pre_condition) { 'class { "::composer": }' }

  describe 'it installs the parameters properly' do
    let(:params) {{
      :entry  => '\'process-timeout\'',
      :value  => 500,
      :ensure => 'present',
      :user   => 'vagrant'
    }}

    it { should contain_exec('composer-config-entry-\'process-timeout\'-vagrant-present') \
      .with_command('/usr/local/bin/composer config -g \'process-timeout\' 500') \
      .with_user('vagrant') \
      .with_environment('HOME=/home/vagrant') \
      .with_unless('/usr/bin/test `/usr/local/bin/composer config -g \'process-timeout\'` = 500') \
    }
  end

  describe 'it removes parameters' do
    let(:params) {{
      :entry  => '\'process-timeout\'',
      :value  => nil,
      :ensure => 'absent',
      :user   => 'vagrant'
    }}

    it { should contain_exec('composer-config-entry-\'process-timeout\'-vagrant-absent') \
      .with_command('/usr/local/bin/composer config -g --unset \'process-timeout\'') \
      .with_user('vagrant') \
      .with_environment('HOME=/home/vagrant')
    }
  end
end
