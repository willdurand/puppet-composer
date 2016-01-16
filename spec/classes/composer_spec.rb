require 'spec_helper'

describe 'composer', :type => :class do
  let(:title) { 'composer' }

  it { should contain_wget__fetch('composer-install') \
    .with_source('https://getcomposer.org/composer.phar') \
    .with_execuser('root') \
    .with_destination('/usr/local/bin/composer')
  }

  it { should contain_file('composer-fix-permissions') \
    .with_mode('a+rx') \
    .with_owner('root') \
    .with_group('root') \
    .with_path('/usr/local/bin/composer')
  }

  it { should_not contain_exec('composer-update') }

  describe 'with a given target_dir' do
    let(:params) {{ :target_dir => '/usr/bin' }}

    it { should contain_wget__fetch('composer-install') \
      .with_source('https://getcomposer.org/composer.phar') \
      .with_execuser('root') \
      .with_destination('/usr/bin/composer')
    }
    
    it { should contain_file('composer-fix-permissions') \
      .with_mode('a+rx') \
      .with_owner('root') \
      .with_group('root') \
      .with_path('/usr/bin/composer')
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

    it { should contain_file('composer-fix-permissions') \
      .with_mode('a+rx') \
      .with_owner('root') \
      .with_group('root') \
      .with_path('/usr/local/bin/c')
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

    it { should contain_file('composer-fix-permissions') \
      .with_mode('a+rx') \
      .with_owner('root') \
      .with_group('root') \
      .with_path('/usr/local/bin/composer')
    }

    it { should contain_exec('composer-update') \
      .with_command('php -d allow_url_fopen=1 /usr/local/bin/composer self-update') \
      .with_user('root') \
      .with_path('/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin')
    }
  end

  describe 'with a given user' do
    let(:params) {{ :user => 'will' }}

    it { should contain_wget__fetch('composer-install') \
      .with_source('https://getcomposer.org/composer.phar') \
      .with_execuser('root') \
      .with_destination('/usr/local/bin/composer')
    }
    

    it { should contain_file('composer-fix-permissions').with({ \
      'ensure' => 'present',
      'owner'  => 'will',
      'group'  => 'root',
      'mode'   => 'a+rx',
      'path'   => '/usr/local/bin/composer'
    })
    }

    it { should_not contain_exec('composer-update') }
  end

  # user + group + RO path + update
  describe 'with a given user + group + path + update' do
    let(:params) {{ 
      :user         => 'will', 
      :group        => 'bofh', 
      :target_dir   => '/opt/project/bin',
      :command_name => 'Composer',
      :auto_update  => true,
     }}

    it { should contain_wget__fetch('composer-install') \
      .with_source('https://getcomposer.org/composer.phar') \
      .with_execuser('root') \
      .with_destination('/opt/project/bin/Composer')
    }


    it { should contain_file('composer-fix-permissions').with({ \
      'ensure' => 'present',
      'owner'  => 'will',
      'group'  => 'bofh',
      'mode'   => 'a+rx',
      'path'   => '/opt/project/bin/Composer'
    })
    }

     it { should contain_exec('composer-update') \
      .with_command('php -d allow_url_fopen=1 /opt/project/bin/Composer self-update') \
      .with_user('will') \
      .with_path('/usr/bin:/bin:/usr/sbin:/sbin:/opt/project/bin')
    }

  end

end
