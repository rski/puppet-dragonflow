# == Class: dragonflow::db::postgresql
#
# Class that configures postgresql for dragonflow
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'dragonflow'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'dragonflow'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
# == Dependencies
#
# == Examples
#
# == Authors
#
# == Copyright
#
class dragonflow::db::postgresql(
  $password,
  $dbname     = 'dragonflow',
  $user       = 'dragonflow',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  Class['dragonflow::db::postgresql'] -> Service<| title == 'dragonflow' |>

  ::openstacklib::db::postgresql { 'dragonflow':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  ::Openstacklib::Db::Postgresql['dragonflow'] ~> Exec<| title == 'dragonflow-manage db_sync' |>

}
