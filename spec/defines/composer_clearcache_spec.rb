require 'spec_helper'

describe 'composer::clearcache', :type => :define do
  let(:title) { 'composer::clearcache' }

  describe 'clear cache with default params' do
    let(:params) {{
      :name => 'vagrant',
    }}

    it { should contain_exec('composer-clear-cache-vagrant') \
      .with_command('composer clear-cache') \
      .with_user('vagrant') \
      .with_environment('HOME=/home/vagrant')
    }
  end

  describe 'clear cache in custom home directory' do
    let(:params) {{
      :name     => 'vagrant',
      :home_dir => '/custom/home/vagrant'
    }}

    it { should contain_exec('composer-clear-cache-vagrant') \
      .with_command('composer clear-cache') \
      .with_user('vagrant') \
      .with_environment('HOME=/custom/home/vagrant')
    }
  end
end
