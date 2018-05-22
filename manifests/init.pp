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
  String $target_dir        = $::composer::params::target_dir,
  String $command_name      = $::composer::params::command_name,
  String $user              = $::composer::params::user,
  Boolean $auto_update      = false,
  Optional[String] $version = undef,
  Optional[String] $group   = undef,
  $download_timeout         = '0',
  Boolean $build_deps       = true,
) inherits ::composer::params {

  if $build_deps {
    ensure_packages(['wget'])
  }

  include composer::params

  $target = $version ? {
    undef   => $::composer::params::phar_location,
    default => "https://getcomposer.org/download/${version}/composer.phar"
  }

  $composer_full_path = "${target_dir}/${command_name}"

  $unless = $version ? {
    undef   => "/usr/bin/test -f ${composer_full_path}",
    default => "/usr/bin/test -f ${composer_full_path} && ${composer_full_path} -V |grep -q ${version}"
  }

  exec { 'composer-install':
    command     => "/usr/bin/wget --no-check-certificate -O ${composer_full_path} ${target}",
    environment => [ "COMPOSER_HOME=${target_dir}" ],
    user        => $user,
    unless      => $unless,
    timeout     => $download_timeout,
    require     => Package['wget'],
  }

  file { "${target_dir}/${command_name}":
    ensure  => file,
    owner   => $user,
    mode    => '0755',
    group   => $group,
    require => Exec['composer-install'],
  }

  $ensure = $auto_update ? { true => present, false => absent }
  cron { 'composer-update':
    ensure  => $ensure,
    command => "COMPOSER_HOME=${target_dir} ${composer_full_path} self-update -q",
    hour    => 0,
    minute  => fqdn_rand(60),
    user    => $user,
    require => File[$composer_full_path],
  }
}
