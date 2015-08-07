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
# [*group*]
#   The group of the composer executable.
#
# [*auto_update*]
#   Whether to run `composer self-update`.
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
  $target_dir   = 'UNDEF',
  $command_name = 'UNDEF',
  $user         = 'UNDEF',
  $group        = 'UNDEF',
  $auto_update  = false
) {

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

  $composer_group = $group ? {
    'UNDEF' => $::composer::params::group,
    default => $group
  }

  # common dependency
  package { patch: 
    ensure => latest
  }


  # fetch composer into target_dir
  wget::fetch { 'composer-install':
    source      => $::composer::params::phar_location,
    destination => "${composer_target_dir}/${composer_command_name}",
    execuser    => 'root',
  }


  # apply user and group permissions to downloaded composer using native puppet File type
  file { 'composer-fix-permissions':
    ensure  => present,
    path    => "${composer_target_dir}/${composer_command_name}",
    owner   => $composer_user,
    group   => $composer_group,
    mode    => 'a+rx',
    recurse => false,
    require => Wget::Fetch['composer-install'],
  }

  # run self update when requested
  if $auto_update {
    exec { 'composer-update':
      command     => "php -d allow_url_fopen=1 ${composer_target_dir}/${composer_command_name} self-update",
      environment => [ 'COMPOSER_HOME=/tmp/' ],
      #
      path        => "/usr/bin:/bin:/usr/sbin:/sbin:${composer_target_dir}",
      user        => $composer_user,
      require     => File['composer-fix-permissions'],
    }
  }
}
