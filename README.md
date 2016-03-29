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
dependencies ([`puppetlabs-stdlib`](https://github.com/puppetlabs/puppetlabs-stdlib)):

    git clone git://github.com/willdurand/puppet-composer.git modules/composer

### ``puppet-wget`` module

The ``puppet-wget`` module is required until version ``1.1.x``, but dropped in version ``1.2.x``.
For further notes about this module, please have a look at the ``1.1`` docs.

In ``1.2`` the ``puppetlabs-stdlib`` dependency has been added in order to
gain lots of puppet features located in this module and improve the type
validation in the manifests.

Usage
-----

### Install composer through puppet

Include the `composer` class:

``` puppet
include composer
```

You can specify the command name you want to get, and the target directory (aka
where to install Composer):

``` puppet
class { '::composer':
  command_name => 'composer',
  target_dir   => '/usr/local/bin'
}
```

You can also auto update composer by using the `auto_update` parameter. This will
update Composer **only** when you will run Puppet.

``` puppet
class { '::composer':
  auto_update => true
}
```

You can specify a particular `user` that will be the owner of the Composer
executable:

``` puppet
class { '::composer':
  user => 'foo',
}
```

As the user is configurable, the group is changeable, too:

``` puppet
class { '::composer':
  group => 'owner_group_name',
}
```

It is also possible to specify a custom composer version:

``` puppet
class { '::composer':
  version => '1.0.0-alpha11',
}
```

When having an infrastructure with slower connections, it is possible to increase the timeout in order to
avoid running into errors because of a slow connection:

``` puppet
class { '::composer':
  download_timeout => '100',
}
```

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

Furthermore it is possible to configure the ``home_dir`` parameter as some users might use another one:

``` puppet
::composer::config { 'composer-vagrant-config':
  ensure   => present,
  user     => 'vagrant',
  home_dir => '/custom/home/dir',
}
```

### Clear cache

The composer dependency resolver is quite complex and there are issues where the cache hides actual conflicts that make reproduction of such issues a lot harder.
In order to keep the cache clean, it is possible to clear the cache via puppet:

``` puppet
::composer::clear_cache { 'clear-cache-for-user':
  exec_user => 'user',
}
```

As the home directory is configurable, it is possible to adjust the homedir to this resource:

``` puppet
::composer::clear_cache { 'clear-cache-for-user':
  home_dir => '/custom/home/dir',
  exec_user     => 'user',
}
```

Handle dependency order
-----------------------

Since this module does only handler the ``composer`` installation, but doesn't care about the ``php`` setup, you might run
into errors due to a missing php instance.
This can be fixed by using the ``require`` parameter:

``` puppet
class { '::composer':
  require => Package['php5'],
}
```

This will puppet tell to wait with the composer install process until the php package is installed.

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
