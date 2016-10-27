# == Class: dragonflow::policy
#
# Configure the dragonflow policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for dragonflow
#   Example :
#     {
#       'dragonflow-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'dragonflow-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (optional) Path to the nova policy.json file
#   Defaults to /etc/dragonflow/policy.json
#
class dragonflow::policy (
  $policies    = {},
  $policy_path = '/etc/dragonflow/policy.json',
) {

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path => $policy_path,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'dragonflow_config': policy_file => $policy_path }

}
