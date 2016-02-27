# = Define: composer::clearcache
#
# == Parameters:
#
# [*home_dir*]
#   Home directory (optional).
#
# == Example:
#
# ::composer::clearcache { 'vagrant': }
#
define composer::clearcache($home_dir = undef) {
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
