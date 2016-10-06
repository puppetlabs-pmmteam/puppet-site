class role::appserver {
  include profile::common
  include profile::nginx
  include profile::apache::remove
  include profile::mysql::client
  include profile::git

  Class['profile::common'] -> Class['profile::nginx']
}
