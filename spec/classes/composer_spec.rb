require 'spec_helper'

describe 'composer', :type => :class do
  let(:title) { 'composer' }

  it { should contain_wget__fetch('composer-install') \
    .with_source('https://getcomposer.org/composer.phar') \
    .with_execuser('root') \
    .with_destination('/usr/local/bin/composer')
  }

    it { should contain_file('/usr/local/bin/composer') \
      .with_owner('root') \
      .with_mode('0755')
    }

  it { should_not contain_exec('composer-update') }

  describe 'with a given target_dir' do
    let(:params) {{ :target_dir => '/usr/bin' }}

    it { should contain_wget__fetch('composer-install') \
      .with_source('https://getcomposer.org/composer.phar') \
      .with_execuser('root') \
      .with_destination('/usr/bin/composer')
    }

    it { should contain_file('/usr/bin/composer') \
      .with_owner('root') \
      .with_mode('0755')
    }

    it { should_not contain_exec('composer-update') }
  end

  describe 'with a given command_name' do
    let(:params) {{ :command_name => 'c' }}

    it { should contain_wget__fetch('composer-install') \
      .with_source('https://getcomposer.org/composer.phar') \
      .with_execuser('root') \
      .with_destination('/usr/local/bin/c')
    }

    it { should contain_file('/usr/local/bin/c') \
      .with_owner('root') \
      .with_mode('0755')
    }

    it { should_not contain_exec('composer-update') }
  end

  describe 'with auto_update => true' do
    let(:params) {{ :auto_update => true }}

    it { should contain_wget__fetch('composer-install') \
      .with_source('https://getcomposer.org/composer.phar') \
      .with_execuser('root') \
      .with_destination('/usr/local/bin/composer')
    }

    it { should contain_file('/usr/local/bin/composer') \
      .with_owner('root') \
      .with_mode('0755')
    }

    it { should contain_exec('composer-update') \
      .with_command('composer self-update') \
      .with_user('root') \
      .with_path('/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin')
    }
  end

  describe 'with a given user' do
    let(:params) {{ :user => 'will' }}

    it { should contain_wget__fetch('composer-install') \
      .with_source('https://getcomposer.org/composer.phar') \
      .with_execuser('will') \
      .with_destination('/usr/local/bin/composer')
    }

    it { should contain_file('/usr/local/bin/composer') \
      .with_owner('will') \
      .with_mode('0755')
    }

    it { should_not contain_exec('composer-update') }
  end

  describe 'with a given version' do
    let(:params) {{ :version => '1.0.0-alpha11' }}

    it { should contain_wget__fetch('composer-install') \
        .with_source('https://getcomposer.org/download/1.0.0-alpha11/composer.phar') \
        .with_execuser('root') \
        .with_destination('/usr/local/bin/composer')
    }
  end
end
