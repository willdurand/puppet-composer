# = Define: composer::config
#
# == Parameters:
#
# [*ensure*]
#   Whether to install or remove the parameters.
#
# [*user*]
#   User which should own the configuration.
#
# [*configs*]
#   Hash that contains the config values.
#
# == Example:
#
#   ::composer::config { 'composer-vagrant':
#     ensure  => present,
#     user    => 'vagrant',
#     configs => {
#       'github-oauth' => {
#         'github.com' => 'token',
#       },
#     },
#   }
#
define composer::config(
  $ensure  = present,
  $user    = undef,
  $configs = {}
) {
  $composer_user = $user ? {
    undef   => $::composer::params::user,
    default => $user
  }

  create_resources('composer::config::entry', create_config_hash($configs, $composer_user, $ensure))
}
