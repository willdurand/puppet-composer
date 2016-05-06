# = Class: composer
#
# == Parameters:
#
# [*target_dir*]
#   Where to install the composer executable.
#
# [*command_name*]
#   The name of the composer executable.
#
# [*user*]
#   The owner of the composer executable.
#
# [*auto_update*]
#   Whether to run `composer self-update`.
#
# [*version*]
#   Custom composer version.
#
# [*group*]
#   Owner group of the composer executable.
#
# [*download_timeout*]
#   The timeout of the download for wget.
#
# == Example:
#
#   include composer
#
#   class { 'composer':
#     'target_dir'   => '/usr/local/bin',
#     'user'         => 'root',
#     'command_name' => 'composer',
#     'auto_update'  => true
#   }
#
class composer (
  $target_dir       = 'UNDEF',
  $command_name     = 'UNDEF',
  $user             = 'UNDEF',
  $auto_update      = false,
  $version          = undef,
  $group            = undef,
  $download_timeout = '0',
) {
  validate_string($target_dir)
  validate_string($command_name)
  validate_string($user)
  validate_bool($auto_update)
  validate_string($version)
  validate_string($group)

  ensure_packages(['wget'])
  include composer::params

  $composer_target_dir = $target_dir ? {
    'UNDEF' => $::composer::params::target_dir,
    default => $target_dir
  }

  $composer_command_name = $command_name ? {
    'UNDEF' => $::composer::params::command_name,
    default => $command_name
  }

  $composer_user = $user ? {
    'UNDEF' => $::composer::params::user,
    default => $user
  }

  $target = $version ? {
    undef   => $::composer::params::phar_location,
    default => "https://getcomposer.org/download/${version}/composer.phar"
  }

  $composer_full_path = "${composer_target_dir}/${composer_command_name}"
  exec { 'composer-install':
    command => "/usr/bin/wget -O ${composer_full_path} ${target}",
    user    => $composer_user,
    creates => $composer_full_path,
    timeout => $download_timeout,
    require => Package['wget'],
  }

  file { "${composer_target_dir}/${composer_command_name}":
    ensure  => file,
    owner   => $composer_user,
    mode    => '0755',
    group   => $group,
    require => Exec['composer-install'],
  }

  if $auto_update {
    exec { 'composer-update':
      command     => "${composer_full_path} self-update",
      environment => [ "COMPOSER_HOME=${composer_target_dir}" ],
      user        => $composer_user,
      require     => File["${composer_target_dir}/${composer_command_name}"],
    }
  }
}
