require 'spec_helper'

describe 'composer::clear_cache', :type => :define do
  let(:title) { '::composer::clear_cache' }
  let(:pre_condition) { 'class { "::composer": }' }

  describe 'clear cache with default params' do
    let(:params) {{
      :exec_user => 'vagrant',
    }}

    it { should contain_exec('composer-clear-cache-vagrant') \
      .with_command('/usr/local/bin/composer clear-cache') \
      .with_user('vagrant') \
      .with_environment('HOME=/home/vagrant')
    }
  end

  describe 'clear cache in custom home directory' do
    let(:params) {{
      :exec_user => 'vagrant',
      :home_dir  => '/custom/home/vagrant'
    }}

    it { should contain_exec('composer-clear-cache-vagrant') \
      .with_command('/usr/local/bin/composer clear-cache') \
      .with_user('vagrant') \
      .with_environment('HOME=/custom/home/vagrant')
    }
  end
end
