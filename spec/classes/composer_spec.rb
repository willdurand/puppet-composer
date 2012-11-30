require 'spec_helper'

describe 'composer', :type => :class do
  let(:title) { 'composer' }

  it { should contain_exec('composer-install') \
    .with_command('wget -O composer http://getcomposer.org/composer.phar') \
    .with_user('root') \
    .with_cwd('/usr/local/bin')
  }

  it { should contain_exec('composer-fix-permissions') \
    .with_command('chmod a+x composer') \
    .with_user('root') \
    .with_cwd('/usr/local/bin')
  }

  describe 'with a given target dir' do
    let(:params) {{ :target_dir => '/usr/bin' }}

    it { should contain_exec('composer-install') \
      .with_command('wget -O composer http://getcomposer.org/composer.phar') \
      .with_user('root') \
      .with_cwd('/usr/bin')
    }

    it { should contain_exec('composer-fix-permissions') \
      .with_command('chmod a+x composer') \
      .with_user('root') \
      .with_cwd('/usr/bin')
    }
  end

  describe 'with a given command name' do
    let(:params) {{ :command_name => 'c' }}

    it { should contain_exec('composer-install') \
      .with_command('wget -O c http://getcomposer.org/composer.phar') \
      .with_user('root') \
      .with_cwd('/usr/local/bin')
    }

    it { should contain_exec('composer-fix-permissions') \
      .with_command('chmod a+x c') \
      .with_user('root') \
      .with_cwd('/usr/local/bin')
    }
  end
end
