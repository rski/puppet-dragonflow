# == Class: dragonflow::config
#
# This class is used to manage arbitrary dragonflow configurations.
#
# === Parameters
#
# [*dragonflow_config*]
#   (optional) Allow configuration of arbitrary dragonflow configurations.
#   The value is an hash of dragonflow_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   dragonflow_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class dragonflow::config (
  $dragonflow_config = {},
) {

  validate_hash($dragonflow_config)

  create_resources('dragonflow_config', $dragonflow_config)
}
