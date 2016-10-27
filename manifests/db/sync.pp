#
# Class to execute dragonflow-manage db_sync
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the dragonflow-dbsync command.
#   Defaults to undef
#
class dragonflow::db::sync(
  $extra_params  = undef,
) {
  exec { 'dragonflow-db-sync':
    command     => "dragonflow-manage db_sync ${extra_params}",
    path        => [ '/bin', '/usr/bin', ],
    user        => 'dragonflow',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    subscribe   => [Package['dragonflow'], Dragonflow_config['database/connection']],
  }

  Exec['dragonflow-manage db_sync'] ~> Service<| title == 'dragonflow' |>
}
