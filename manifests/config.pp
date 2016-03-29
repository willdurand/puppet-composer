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
# [*home_dir*]
#   Home directory (if the user uses a custom home directory).
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
  $ensure   = present,
  $user     = undef,
  $configs  = {},
  $home_dir = undef,
) {
  validate_string($user)

  $composer_user = $user ? {
    undef   => $::composer::params::user,
    default => $user
  }

  create_resources('composer::config::entry', create_config_hash($configs, $composer_user, $ensure, $home_dir))
}
