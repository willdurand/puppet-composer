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
# == Example:
#
#   include composer
#
#   class { 'composer':
#     'target_dir'   => '/usr/local/bin',
#     'command_name' => 'composer'
#   }
#
class composer (
  $target_dir   = 'UNDEF',
  $command_name = 'UNDEF',
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

  exec { 'composer-install':
    command => "wget -O ${composer_command_name} ${::composer::params::phar_location}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => $composer_target_dir,
    user    => 'root',
    unless  => "test -f ${composer_target_dir}/${composer_command_name}",
  }

  exec { 'composer-fix-permissions':
    command => "chmod a+x ${composer_command_name}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => $composer_target_dir,
    user    => 'root',
    unless  => "test -x ${composer_target_dir}/${composer_command_name}",
    require => Exec['composer-install'],
  }

  if $auto_update {
    exec { 'composer-update':
      command => "${composer_command_name} self-update",
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      cwd     => $composer_target_dir,
      user    => 'root',
      require => Exec['composer-fix-permissions'],
    }
  }
}
