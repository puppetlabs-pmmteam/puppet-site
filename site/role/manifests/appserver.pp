class role::appserver(
  $use_puppetconf_header = false
) {
  include profile::common
  include profile::secret_example
  include profile::corrective_change_example
  include profile::apache::remove
  include profile::nginx
  include profile::mysql::client
  include profile::git

  Class['profile::common'] -> Class['profile::nginx']
  Class['profile::apache::remove'] -> Class['profile::nginx']
}
