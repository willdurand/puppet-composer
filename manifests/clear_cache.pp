# = Define: composer::clear_cache
#
# == Parameters:
#
# [*home_dir*]
#   Home directory (optional).
#
# == Example:
#
# ::composer::clear_cache { 'vagrant': }
#
define composer::clear_cache($home_dir = undef) {
  $home = $home_dir ? {
    undef   => "/home/${name}",
    default => $home_dir
  }

  exec { "composer-clear-cache-${name}":
    command     => 'composer clear-cache',
    user        => $name,
    environment => "HOME=${home}",
    path        => $::path,
    require     => Class['::composer'],
  }
}
