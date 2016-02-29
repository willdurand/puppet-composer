puppet-composer
===============

[![Build
Status](https://secure.travis-ci.org/willdurand/puppet-composer.png)](http://travis-ci.org/willdurand/puppet-composer)

This module installs [Composer](http://getcomposer.org/), a dependency manager
for PHP.

Installation
------------

Using the Puppet Module Tool, install the
[`willdurand/composer`](http://forge.puppetlabs.com/willdurand/composer) by
running the following command:

    puppet module install willdurand/composer

Otherwise, clone this repository and make sure to install the proper
dependencies ([`puppet-wget`](https://github.com/maestrodev/puppet-wget)):

    git clone git://github.com/willdurand/puppet-composer.git modules/composer

**Important:** the right `puppet-wget` module is
[maestrodev/puppet-wget](https://github.com/maestrodev/puppet-wget). You should
**not** use any other `puppet-wget` module. Example42's module won't work for
instance. So, please, run the following command:

    git clone git://github.com/maestrodev/puppet-wget.git modules/wget


Usage
-----

### Install composer through puppet

Include the `composer` class:

    include composer

You can specify the command name you want to get, and the target directory (aka
where to install Composer):

    class { 'composer':
      command_name => 'composer',
      target_dir   => '/usr/local/bin'
    }

You can also auto update composer by using the `auto_update` parameter. This will
update Composer **only** when you will run Puppet.

    class { 'composer':
      auto_update => true
    }

You can specify a particular `user` that will be the owner of the Composer
executable:

    class { 'composer':
      user => 'foo',
    }

As the user is configurable, the group is changeable, too:

    class { 'composer':
      group => 'owner_group_name',
    }

It is also possible to specify a custom composer version:

    class { 'composer':
      version => '1.0.0-alpha11',
    }

### Global composer configs

One feature of composer are [global configuration parameters](https://getcomposer.org/doc/06-config.md#config).
There are some important parameters like ``oauth_token`` for the GitHub API that should be configured through composer.

``` puppet
::composer::config { 'composer-vagrant-config':
  ensure  => present,
  user    => 'vagrant',
  configs => {
    'github-oauth' => {
      'github.com' => 'token'
    },
    'process-timeout' => 500,
    'http-basic' => {
      'github.com' => ['username', 'password']
    },
  },
}
```

And removing single params is also possible:

``` puppet
::composer::config { 'remove-platform':
  ensure  => absent,
  configs => ['process-timeout', 'github-oauth.github.com', 'http-basic.github.com'],
  user    => 'vagrant',
}
```

Note that the config items must be structured like when using the CLI. This means that when having a ``gitlab-oauth`` entry for site ``gitlab.org`` then the following key should be removed:

    gitlab-oauth.gitlab.org

### Clear cache

The composer dependency resolver is quite complex and there are issues where the cache hides actual conflicts that make reproduction of such issues a lot harder.
In order to keep the cache clean, it is possible to clear the cache via puppet:

``` puppet
::composer::clear_cache { 'user': }
```

As the home directory is configurable, it is possible to adjust the homedir to this resource:

``` puppet
::composer::clear_cache { 'user':
  home_dir => '/custom/home/dir',
}
```

Handle dependency order
-----------------------

Handle the PHP dependency with custom stages. Make composer wait for PHP. 

    class { 'composer':
      command_name => 'composer',
      target_dir   => '/usr/local/bin', 
      auto_update => true, 
      stage => last,
    }
    stage { 'last': }
    Stage['main'] -> Stage['last']

Custom stages reference: http://docs.puppetlabs.com/puppet/3/reference/lang_run_stages.html

Running the tests
-----------------

Install the dependencies using [Bundler](http://gembundler.com):

    BUNDLE_GEMFILE=.gemfile bundle install

Run the following command:

    BUNDLE_GEMFILE=.gemfile bundle exec rake spec


License
-------

puppet-composer is released under the MIT License. See the bundled LICENSE file
for details.
