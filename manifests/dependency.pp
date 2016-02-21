# = Define: ::composer::dependency
#
# == Parameters:
#
# [*ensure*]
#   Ensure whether to install or remove the dependency.
#
# [*cwd*]
#   Working directory (where to install the dependency).
#
# [*user*]
#   User that should execute the command.
#
# [*constraint*]
#   SemVer constraint of the package.
#
# [*no_dev*]
#   Whether to install dev dependencies or not.
#
# [*no_update*]
#   Whether to run the update after this or not.
#
# [*options*]
#   More CLI options for the composer command.
#
# [*dependency_name*]
#   Name of the dependency.
#
# == Example:
#
#   # installing a dependency globally
#   ::composer::dependency { 'phpunit-global':
#     ensure          => present,
#     global          => true,
#     dependency_name => 'phpunit/phpunit',
#     constraint      => '^3.0',
#     options         => '--dry-run --optimize-autoloader',
#     user            => 'vagrant',
#     no_update       => false, # default
#     no_dev          => true,  # default
#   }
#
#   # installing a dependency locally
#   ::composer::dependency { 'project-symfony':
#     ensure          => present,
#     dependency_name => 'phpunit/phpunit',
#     constraint      => '^3.0',
#     options         => '--dry-run --optimize-autoloader',
#     user            => 'vagrant',
#     cwd             => '/var/www/project',
#   }
#
define composer::dependency(
  $ensure     = present,
  $cwd        = undef,
  $user       = undef,
  $constraint = undef,
  $no_dev     = true,
  $no_update  = false,
  $options    = undef,
  $global     = false,
  $dependency_name
) {
  $exec_user = $user ? {
    undef   => $::composer::params::user,
    default => $user,
  }

  $action = $ensure ? {
    present => 'require',
    default => 'remove',
  }

  $no_dev_option = $no_dev ? {
    true    => '--no-dev',
    default => undef,
  }

  $no_update_option = $no_update ? {
    true    => '--no-update',
    default => undef,
  }

  $dependency_string = $constraint ? {
    undef   => $dependency_name,
    default => "${dependency_name}:${constraint}"
  }

  $cli_options = "${no_dev_option} ${no_update_option} ${options}"

  if $cwd != undef {
    ensure_resource('file', $cwd, { ensure => present })

    $composer_cmd = 'composer'
  }
  elsif $global {
    $composer_cmd = 'composer global'
  }
  else {
    fail('Either "$cwd" must have a value or "$global" must be true!')
  }

  exec { "composer-${action}-${dependency_name}":
    cwd     => $cwd,
    user    => $exec_user,
    command => "${composer_cmd} ${action} ${dependency_string} ${cli_options}",
    require => Class['::composer'],
  }
}
