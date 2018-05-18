# = Define: composer::clear_cache
#
# == Parameters:
#
# [*home_dir*]
#   Home directory (optional).
#
# [*exec_user*]
#   Execution user.
#
# == Example:
#
# ::composer::clear_cache { 'cleanup-for-vagrant':
#   exec_user => 'vagrant',
# }
#
define composer::clear_cache(String $exec_user, Optional[String] $home_dir = undef) {

  $home = $home_dir ? {
    undef   => "/home/${exec_user}",
    default => $home_dir
  }

  exec { "composer-clear-cache-${exec_user}":
    command     => "${::composer::composer_full_path} clear-cache",
    user        => $exec_user,
    environment => "HOME=${home}",
    require     => Class['::composer'],
  }
}
