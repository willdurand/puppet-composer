require 'spec_helper'

describe 'composer::config', :type => :define do
  let(:title) { '::composer::config' }
  let(:pre_condition) { 'class { "::composer": }' }

  describe 'it installs the parameters properly' do
    let(:params) {{
      :ensure  => 'present',
      :user    => 'vagrant',
      :configs => {
        'github-oauth' => {
          'github.com' => 'token'
        },
        'http-basic' => {
          'github.com' => ['username', 'password']
        },
      },
    }}

    it { should contain_exec('composer-config-entry-\'github-oauth\'.\'github.com\'-vagrant-present') \
      .with_command('/usr/local/bin/composer config -g \'github-oauth\'.\'github.com\' token') \
      .with_user('vagrant') \
      .with_environment('HOME=/home/vagrant')
    }

    it { should contain_exec('composer-config-entry-\'http-basic\'.\'github.com\'-vagrant-present') \
      .with_command('/usr/local/bin/composer config -g \'http-basic\'.\'github.com\' username password') \
      .with_user('vagrant') \
      .with_environment('HOME=/home/vagrant')
    }
  end

  describe 'it removes parameters properly' do
    let(:params) {{
      :ensure  => 'absent',
      :user    => 'vagrant',
      :configs => ['github-oauth.github.com', 'process-timeout']
    }}

    it { should contain_exec('composer-config-entry-github-oauth.github.com-vagrant-absent') \
      .with_command('/usr/local/bin/composer config -g --unset github-oauth.github.com')
      .with_user('vagrant')
      .with_environment('HOME=/home/vagrant')
    }

    it { should contain_exec('composer-config-entry-process-timeout-vagrant-absent') \
      .with_command('/usr/local/bin/composer config -g --unset process-timeout')
      .with_user('vagrant')
      .with_environment('HOME=/home/vagrant')
    }
  end

  describe 'it can adjust a custom `HOME` environment variable for config operations' do
    let(:params) {{
      :ensure  => 'present',
      :user    => 'vagrant',
      :configs => {
        'process-timeout' => 500
      },
      :home_dir => '/custom/home/dir',
    }}

    it { should contain_composer__config__entry('process-timeout-vagrant-create') \
      .with_custom_home_dir('/custom/home/dir') \
    }
  end
end
