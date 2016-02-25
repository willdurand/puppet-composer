# = Define: composer::config::entry
#
# == Parameters:
#
# [*ensure*]
#   Whether to apply or remove the config entry.
#
# [*entry*]
#   Parameter name.
#
# [*value*]
#   Configuration value.
#
# [*user*]
#   User which should own the configs.
#
define composer::config::entry($entry, $user, $ensure, $value = undef) {
  if $caller_module_name != $module_name {
    warning('::composer::config::entry is not meant for public use!')
  }

  $home_dir     = "/home/${user}"
  $cmd_template = "${::composer::composer_command_name} config -g"
  $cmd          = $ensure ? {
    present => "${cmd_template} ${entry} ${value}",
    default => "${cmd_template} --unset ${entry}"
  }

  exec { "composer-config-entry-${entry}-${user}-${ensure}":
    command     => $cmd,
    user        => $user,
    require     => Class['::composer'],
    environment => "HOME=${home_dir}",
  }
}
